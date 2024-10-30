# frozen_string_literal: true

module Templates
  module Config
    module Utility
      class PolymorphicTemplateSet
        include ActiveModel::Validations
        include ActiveModel::Validations::Callbacks
        include Enumerable

        # @return [<Templates::Config::Utility::UnacceptableTemplateError>]
        attr_accessor :errors

        # @return [<Templates::Config::Utility::AbstractTemplate>]
        attr_accessor :templates

        def initialize(errors: [], templates: [])
          @errors = Array(errors)
          @templates = Array(templates)
        end

        # @param [Templates::Config::Utility::AbstractTemplate] template
        def <<(template)
          @templates << template

          self
        end

        # Enumerate over each template in the set.
        #
        # @yield [template] Each template is returned in deterministic order.
        # @yieldparam [Templates::Config::Utility::AbstractTemplate] template
        # @yieldreturn [void]
        # @return [void]
        def each
          return enum_for(__method__) unless block_given?

          @templates.each do |template|
            yield template
          end
        end
      end
    end
  end
end
