# frozen_string_literal: true

module Support
  # A concern for generators that accept fields to define in GraphQL objects, mutations, etc.
  module GeneratesGQLFields
    extend ActiveSupport::Concern

    included do
      argument :custom_fields,
        type: :array,
        default: [],
        banner: "name:type name:type ...",
        desc: "Fields for this object (type may be expressed as Ruby or GraphQL)"
    end

    private

    # @!attribute [r] normalized_gql_fields
    # @return [<Support::NormalizedGQL::Field>]
    def normalized_gql_fields
      @normalized_gql_fields ||= Support::System["normalize_gql_fields"].(custom_fields)
    end
  end
end
