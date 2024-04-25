# frozen_string_literal: true

module Patches
  module IrregularCamelization
    def underscore(camel_cased_word)
      ActiveSupport::Inflector.irregular_camelizations.fetch camel_cased_word do
        super
      end
    end

    class << self
      def prepended(base)
        base.extend Patches::IrregularCamelization::ClassMethods
      end
    end

    module ClassMethods
      # @param [<#to_s>] defaults
      # @param [{ Symbol => Object }] pairs
      # @return [void]
      def irregular_camelizations!(*defaults, **pairs)
        defaults.each do |default|
          underscored = default.to_s
          camelized = underscored.camelize(:lower)

          irregular_camelizations[camelized] = underscored
        end

        irregular_camelizations.merge! pairs.invert.transform_values(&:to_s)
      end

      def irregular_camelizations
        @irregular_camelizations ||= {}.with_indifferent_access
      end
    end
  end
end

ActiveSupport::Inflector.prepend Patches::IrregularCamelization
