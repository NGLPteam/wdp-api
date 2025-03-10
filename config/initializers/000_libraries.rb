# frozen_string_literal: true

require "base64"
require "i18n"
require "graphql/client"
require "graphql/client/http"
require "net/http"
require "sorted_set"
require "with_advisory_lock"

require_relative Rails.root.join("lib", "global_types", "array_types")
require_relative Rails.root.join("lib", "global_types", "indifferent_hash")
require_relative Rails.root.join("lib", "global_types", "property_hash")
require_relative Rails.root.join("lib", "global_types", "semantic_version")
require_relative Rails.root.join("lib", "global_types", "variable_precision_date")
require_relative Rails.root.join("lib", "global_types", "version_requirement")

I18n.backend.eager_load!

Oj.optimize_rails

[Dry::Schema, Dry::Validation::Contract].each do |lib|
  lib.config.messages.backend = :i18n
  lib.config.messages.load_paths << Rails.root.join("config", "locales", "en.yml").realpath
end

ActiveModel::Type.register :any_array, GlobalTypes::AnyArray
ActiveModel::Type.register :any_json, GlobalTypes::AnyJSON
ActiveModel::Type.register :string_array, GlobalTypes::StringArray
ActiveModel::Type.register :integer_array, GlobalTypes::IntegerArray

ActiveModel::Type.register :indifferent_hash, GlobalTypes::IndifferentHash
ActiveModel::Type.register :property_hash, GlobalTypes::PropertyHash
ActiveModel::Type.register :semantic_version, GlobalTypes::SemanticVersion
ActiveModel::Type.register :variable_precision_date, GlobalTypes::VariablePrecisionDate
ActiveModel::Type.register :version_requirement, GlobalTypes::VersionRequirement

ActiveRecord::Type.register :indifferent_hash, GlobalTypes::IndifferentHash
ActiveRecord::Type.register :property_hash, GlobalTypes::PropertyHash
ActiveRecord::Type.register :semantic_version, GlobalTypes::SemanticVersion
ActiveRecord::Type.register :variable_precision_date, GlobalTypes::VariablePrecisionDate
ActiveRecord::Type.register :version_requirement, GlobalTypes::VersionRequirement
