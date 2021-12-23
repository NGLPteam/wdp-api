# frozen_string_literal: true

require "base64"
require "i18n"
require "dry/core/equalizer"
require "dry/core/memoizable"
require "dry/matcher/result_matcher"
require "dry/transformer/all"
require "dry/schema"
require "dry/types"
require "dry/validation"
require "faraday_middleware"
require "net/http"
require "sidekiq/api"

require_relative Rails.root.join("lib", "global_types", "array_types")
require_relative Rails.root.join("lib", "global_types", "indifferent_hash")
require_relative Rails.root.join("lib", "global_types", "semantic_version")
require_relative Rails.root.join("lib", "global_types", "variable_precision_date")
require_relative Rails.root.join("lib", "global_types", "version_requirement")

I18n.backend.eager_load!

[Dry::Schema, Dry::Validation::Contract].each do |lib|
  lib.config.messages.backend = :i18n
  lib.config.messages.load_paths << Rails.root.join("config", "locales", "en.yml").realpath
end

Dry::Schema.load_extensions :hints
Dry::Schema.load_extensions :info
Dry::Schema.load_extensions :monads
Dry::Types.load_extensions :monads
Dry::Validation.load_extensions :monads
Dry::Validation.load_extensions :predicates_as_macros

FrozenRecord::Base.auto_reloading = Rails.env.development?
FrozenRecord::Base.base_path = Rails.root.join("lib", "frozen_record")

ActiveModel::Type.register :any_array, GlobalTypes::AnyArray
ActiveModel::Type.register :any_json, GlobalTypes::AnyJSON
ActiveModel::Type.register :string_array, GlobalTypes::StringArray
ActiveModel::Type.register :integer_array, GlobalTypes::IntegerArray

ActiveModel::Type.register :indifferent_hash, GlobalTypes::IndifferentHash
ActiveModel::Type.register :semantic_version, GlobalTypes::SemanticVersion
ActiveModel::Type.register :version_requirement, GlobalTypes::VersionRequirement

ActiveRecord::Type.register :indifferent_hash, GlobalTypes::IndifferentHash
ActiveRecord::Type.register :semantic_version, GlobalTypes::SemanticVersion
ActiveRecord::Type.register :version_requirement, GlobalTypes::VersionRequirement
