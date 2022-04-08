# frozen_string_literal: true

module FrozenSchema
  extend ActiveSupport::Concern

  included do
    extend Dry::Core::ClassAttributes

    defines :schema, type: Dry::Types::Nominal.new(Dry::Schema::Processor)
  end

  class_methods do
    # @note We repurpose this built-in method to apply our schema
    def assign_defaults!(record)
      return super if schema.blank?

      result = schema.call record

      return result.to_monad.value! if result.failure?

      result.to_h.stringify_keys
    end

    def default_attributes
      schema.present? ? {} : nil
    end

    def schema!(&block)
      defined = Dry::Schema.Params(&block)

      schema defined
    end
  end
end
