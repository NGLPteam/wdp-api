# frozen_string_literal: true

module MutationOperations
  # @api private
  class UserError < Shared::FlexibleStruct
    attribute :message, AppTypes::String
    attribute :code, AppTypes::Coercible::String.optional
    attribute :path, AppTypes::AttributePath
    attribute :attribute_path, AppTypes::String
    attribute :global, AppTypes::Bool

    # The default type for errors if a code was not provided
    SERVER = "$server"

    def global?
      global.present?
    end

    # @return [(String, String)]
    def attribute_error_key
      [attribute_path, type]
    end

    def scope
      global? ? "global" : "attribute"
    end

    def to_global_error
      {
        message:,
        type:,
      }
    end

    # @return [String]
    def type
      code.presence || SERVER
    end
  end
end
