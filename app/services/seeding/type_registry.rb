# frozen_string_literal: true

module Seeding
  # The shared type registry used by {Seeding::Contracts::Base}.
  TypeRegistry = Dry::Schema::TypeContainer.new

  TypeRegistry.register "json.asset", Seeding::Types::Any # Seeding::Import::Structs::Assets::Any
  TypeRegistry.register "json.community_schema", Seeding::Types::CommunitySchema
  TypeRegistry.register "json.collection_schema", Seeding::Types::CollectionSchema
  TypeRegistry.register "json.full_text", ::FullText::Types::NormalizedReference
  TypeRegistry.register "json.import_version", Seeding::Types::ImportVersion
  TypeRegistry.register "json.safe_string", Seeding::Types::Coercible::String
  TypeRegistry.register "json.string_list", Seeding::Types::CoercibleStringList
end
