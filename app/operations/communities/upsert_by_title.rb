# frozen_string_literal: true

module Communities
  # @operation
  class UpsertByTitle
    include Dry::Monads[:result]
    include MonadicPersistence

    # @param [String] title
    # @return [Dry::Monads::Success(Community)]
    def call(title)
      community = Community.where(title:).first_or_initialize

      yield community if block_given?

      community.schema_version = SchemaVersion["default:community"] unless community.schema_version_id?

      monadic_save community
    end
  end
end
