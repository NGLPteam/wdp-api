# frozen_string_literal: true

module Communities
  # @operation
  class Upsert
    include Dry::Monads[:result]
    include MonadicPersistence

    # @param [String] identifier
    # @param [String] title
    # @return [Dry::Monads::Success(Community)]
    def call(identifier, title: nil)
      community = Community.by_identifier(identifier).first_or_initialize

      yield community if block_given?

      community.title = title if title.present?

      community.schema_version = SchemaVersion["default:community"] unless community.schema_version_id?

      monadic_save community
    end
  end
end
