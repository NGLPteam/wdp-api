# frozen_string_literal: true

module LiquidExt
  module Tags
    # We'd like the ability to check for the presence of an entire chain call in Liquid
    # without having to enumerate. In addition, we'd like Rails `present?` logic instead
    # of the Rubyish truthiness checks. This tag accomplishes that.
    class IfPresent < Liquid::Block
      Syntax = /(#{Liquid::QuotedFragment})\s*([=!<>a-z_]+)?\s*(#{Liquid::QuotedFragment})?/o

      ExpressionsAndOperators = /(?:\b(?:\s?and\s?|\s?or\s?)\b|(?:\s*(?!\b(?:\s?and\s?|\s?or\s?)\b)(?:#{Liquid::QuotedFragment}|\S+)\s*)+)/o

      BOOLEAN_OPERATORS = %w[and or].freeze

      ELSE_TAG_NAMES = %w[elsifpresent else].freeze

      private_constant :ELSE_TAG_NAMES

      attr_reader :blocks

      def initialize(tag_name, markup, options)
        super
        @blocks = []
        push_block("if", markup)
      end

      def nodelist
        # :nocov:
        @blocks.map(&:attachment)
        # :nocov:
      end

      def parse(tokens)
        while parse_body(@blocks.last.attachment, tokens); end

        @blocks.reverse_each do |block|
          # :nocov:
          block.attachment.remove_blank_strings if blank?
          # :nocov:
          block.attachment.freeze
        end
      end

      def unknown_tag(tag, markup, tokens)
        if ELSE_TAG_NAMES.include?(tag)
          push_block(tag, markup)
        else
          # :nocov:
          super
          # :nocov:
        end
      end

      def render_to_output_buffer(context, output)
        @blocks.each do |block|
          result = Liquid::Utils.to_liquid_value(
            block.evaluate(context),
          )
        rescue Liquid::UndefinedVariable, Liquid::UndefinedDropMethod
          # We allow undefined variables and drop method calls to occur here, regardless of strict variables.
          next
        else
          if check_presence?(result)
            return block.attachment.render_to_output_buffer(context, output)
          end
        end

        # :nocov:
        output
        # :nocov:
      end

      private

      # @param [Object] result
      def check_presence?(result)
        case result
        when ::LiquidExt::Behavior::BlankAndPresent
          result.is_present
        else
          result.present?
        end
      end

      def push_block(tag, markup)
        block =
          if tag == "else"
            Liquid::ElseCondition.new
          else
            parse_with_selected_parser(markup)
          end

        @blocks.push(block)

        block.attach(new_body)
      end

      def parse_expression(markup)
        Liquid::Condition.parse_expression(parse_context, markup)
      end

      def lax_parse(markup)
        expressions = markup.scan(ExpressionsAndOperators)

        # :nocov:
        raise Liquid::SyntaxError, options[:locale].t("errors.syntax.if") unless expressions.pop =~ Syntax
        # :nocov:

        condition = Liquid::Condition.new(parse_expression(Regexp.last_match(1)), Regexp.last_match(2), parse_expression(Regexp.last_match(3)))

        until expressions.empty?
          operator = expressions.pop.to_s.strip

          # :nocov:
          raise Liquid::SyntaxError, options[:locale].t("errors.syntax.if") unless expressions.pop.to_s =~ Syntax
          # :nocov:

          new_condition = Liquid::Condition.new(parse_expression(Regexp.last_match(1)), Regexp.last_match(2), parse_expression(Regexp.last_match(3)))

          # :nocov:
          raise Liquid::SyntaxError, options[:locale].t("errors.syntax.if") unless BOOLEAN_OPERATORS.include?(operator)
          # :nocov:

          new_condition.send(operator, condition)

          condition = new_condition
        end

        condition
      end

      def strict_parse(markup)
        p = @parse_context.new_parser(markup)
        condition = parse_binary_comparisons(p)
        p.consume(:end_of_string)
        condition
      end

      def parse_binary_comparisons(p)
        condition = parse_comparison(p)
        first_condition = condition
        while (op = p.id?("and") || p.id?("or"))
          child_condition = parse_comparison(p)
          condition.send(op, child_condition)
          condition = child_condition
        end
        first_condition
      end

      def parse_comparison(p)
        a = parse_expression(p.expression)
        if (op = p.consume?(:comparison))
          # :nocov:
          b = parse_expression(p.expression)
          Liquid::Condition.new(a, op, b)
          # :nocov:
        else
          Liquid::Condition.new(a)
        end
      end

      class ParseTreeVisitor < Liquid::ParseTreeVisitor
        def children
          # :nocov:
          @node.blocks
          # :nocov:
        end
      end
    end
  end
end
