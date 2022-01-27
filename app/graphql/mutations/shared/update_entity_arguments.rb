# frozen_string_literal: true

module Mutations
  module Shared
    # Shared arguments and fields that apply to updating any {Community}, {Collection}, or {Item}.
    #
    # @see Mutations::Shared::UpdatesEntity
    module UpdateEntityArguments
      extend ActiveSupport::Concern

      include Mutations::Shared::EntityArguments

      included do
        clearable_attachment! :hero_image
        clearable_attachment! :thumbnail

        field :schema_errors, [Types::SchemaValueErrorType, { null: false } ], null: false

        argument :schema_properties, GraphQL::Types::JSON, required: false, transient: true do
          description <<~TEXT.strip_heredoc
          An arbitrary set of property values. Owing to the dynamic nature, they do not have a specific GraphQL input type
          associated with them. Validation will be performed within the application and returned as errors if not valid.
          TEXT
        end
      end
    end
  end
end
