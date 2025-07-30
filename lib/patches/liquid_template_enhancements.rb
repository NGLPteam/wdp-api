# frozen_string_literal: true

module Patches
  module LiquidTemplateEnhancements
    # @param [String] markup
    # @return [Object]
    def lookup_expression(markup)
      lookup = Liquid::VariableLookup.new(markup)

      lookup.evaluate(build_context_for_expression_lookup)
    end

    # @api private
    # @return [Liquid::Context]
    def build_context_for_expression_lookup
      Liquid::Context.new(assigns, instance_assigns, registers, @rethrow_errors, @resource_limits, {}, @environment)
    end
  end
end

Liquid::Template.include Patches::LiquidTemplateEnhancements
