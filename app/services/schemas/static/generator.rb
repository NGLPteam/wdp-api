# frozen_string_literal: true

module Schemas
  module Static
    # @abstract
    class Generator
      extend ActiveModel::Callbacks

      include Schemas::Static::Import[definitions: "definitions.map"]
      include WDPAPI::Deps[parse_variable_date: "variable_precision.parse_date"]

      define_model_callbacks :generate, :finalize

      delegate :static_schema_key, to: :class

      attr_reader :definition

      # @return [{ Symbol => Object }]
      def call(entity: nil)
        @entity = entity

        @properties = {}

        load_definition!

        run_callbacks :generate do
          generate
        end

        run_callbacks :finalize do
          finalize!
        end

        @properties
      ensure
        @properties = nil
        @entity = nil
      end

      # @abstract
      # @return [void]
      def generate; end

      # @api private
      # @param [String, Symbol] key
      # @yield [props]
      # @yieldparam [{ Symbol => Object }]
      # @yieldreturn [Object]
      # @return [void]
      def calculate!(key)
        value = yield @properties.dup.freeze

        set! key, value
      end

      def set!(key, value, skip_chance: nil)
        return if skip_chance.present? && percent_chance?(skip_chance)

        case key
        when /\A(?<group_name>[^.\s]+)\.(?<prop_name>[^.\s]+)\z/
          set_group! Regexp.last_match[:group_name], Regexp.last_match[:prop_name], value
        when String, Symbol
          set_in_hash! @properties, key.to_sym, value
        else
          # :nocov:
          raise TypeError, "Don't know how to set property with #{key.inspect}"
          # :nocov:
        end
      end

      def set_variable_precision_date!(key, value)
        set! key, parse_variable_date.call(value).value_or(nil)
      end

      # @api private
      # @param [String, Symbol] key
      # @param [Integer, Float] chance
      # @return [void]
      def set_random_boolean!(key, chance: 50)
        value = percentage chance

        set! key, value
      end

      # @api private
      # Sets a random option based on its defined available options.
      #
      # @note Uses {#log_chance} to create some distributed randomness
      # @param [String, Symbol] key
      # @return [void]
      def set_random_option!(key)
        values = select_option_values_for key

        value = log_chance(*values)

        set! key, value
      end

      def set_random_year!(key, from: 1950, to: Date.current.year)
        year = rand(from..to).to_s

        set_variable_precision_date! key, year
      end

      def set_random_year_month!(key, from: 1950, to: Date.current.year)
        year = rand(from..to).to_s

        month = rand(1..12).to_s

        value = "%04d-%02d" % [year, month]

        set_variable_precision_date! key, value
      end

      def random_paragraph
        Faker::Lorem.paragraph(sentence_count: 3..7, supplemental: true, random_sentences_to_add: 4)
      end

      def random_markdown(title: Faker::Lorem.sentence, subtitle: Faker::Lorem.sentence)
        <<~TEXT.strip_heredoc.strip
        # #{title}

        #{random_paragraph}

        ## #{subtitle}

        #{random_paragraph}
        TEXT
      end

      # @api private
      # @param [Integer, Range<Integer>] count
      # @return [<String>]
      def random_colors(count: 1..5)
        sample_count = count.kind_of?(Range) ? rand(count) : rand(1..count)

        Faker::Color.fetch_all("color.name").sample(sample_count)
      end

      private

      def finalize!
        @properties.deep_transform_values! do |value|
          cast_value value
        end
      end

      def cast_value(value)
        case value
        when Array, ActiveRecord::Relation
          value.map do |element|
            cast_value element
          end
        when ApplicationRecord
          value.to_encoded_id
        else
          value
        end
      end

      def set_group!(group_name, name, value, **options)
        enforce_group! group_name do |g|
          set_in_hash! g, name, value
        end
      end

      def set_in_hash!(target, name, value)
        target[name.to_sym] = value
      end

      def enforce_group!(name)
        key = name.to_sym

        @properties[key] ||= {}

        value = @properties[key]

        if value.kind_of?(Hash)
          yield value if block_given?

          return
        end

        # :nocov:
        raise TypeError, "Expected @properties[:#{key}] to be a hash, but got: #{@properties[key].inspect}"
        # :nocov:
      end

      def load_definition
        return {} if static_schema_key.blank?

        definitions[static_schema_key].latest&.raw_data || {}
      rescue Dry::Container::Error
        return {}
      end

      def load_definition!
        @definition = load_definition

        @select_options = {}.with_indifferent_access
        @select_option_values = {}.with_indifferent_access

        extract_select_option_values! @definition[:properties]
      end

      def log_chance(*list)
        return nil if list.blank?

        return list.first if list.one?

        size = list.size

        list[-Math.log2(rand(2**size - 1) + 1).floor - 1]
      end

      # @param [Float, Integer] value
      # @return [Boolean]
      def percentage(value)
        value = value.fdiv(100).round(1) if value > 1

        rand < value
      end

      alias percent_chance? percentage

      # @return [void]
      def extract_select_option_values!(properties, prefix: nil)
        Array(properties).each do |prop|
          case prop[:type]
          when "group"
            extract_select_option_values! prop[:properties], prefix: prop[:path]
          when "select", "multiselect"
            options = Array(prop[:options])

            full_path = prefix ? [prefix, prop[:path]].join(?.) : prop[:path]

            @select_options[full_path] = options
            @select_option_values[full_path] = options.pluck(:value).compact
          end
        end
      end

      def select_option_values_for(key)
        @select_option_values.fetch(key)
      end

      class << self
        def static_schema_key
          return nil if self == Schemas::Static::Generator

          @static_schema_key ||= name.gsub(/\ASchemas::Static::Generate::/, "").split("::", 2).map(&:underscore).join(?.)
        end
      end
    end
  end
end
