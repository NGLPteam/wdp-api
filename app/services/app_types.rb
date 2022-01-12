# frozen_string_literal: true

module AppTypes
  include Dry.Types

  extend Shared::EnhancedTypes

  UUID_PATTERN = /\A[0-9a-f]{8}\b-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-\b[0-9a-f]{12}\z/i.freeze

  UUID = AppTypes::String.constrained(format: UUID_PATTERN)

  EMAIL_PATTERN = URI::MailTo::EMAIL_REGEXP

  SLUG_PATTERN = /\A[a-z0-9]+(?:-[a-z0-9]+)*\z/.freeze

  UUIDList = Array.of(AppTypes::UUID).constrained(min_size: 1)

  CoercibleEmail = Coercible::String.constrained(format: EMAIL_PATTERN).optional

  Email = String.constrained(format: EMAIL_PATTERN)

  EntityVisibility = Coercible::String.enum("visible", "hidden", "limited")

  IntList = AppTypes::Array.of(AppTypes::Integer)

  StringList = AppTypes::Array.of(AppTypes::String)

  CoercibleStringList = AppTypes::Coercible::Array.of(AppTypes::Coercible::String)

  AttributePath = AppTypes::Array.of(AppTypes::Integer | AppTypes::Coercible::String)

  JWTIssuer = (AppTypes::String | StringList).optional

  ContributorKind = AppTypes::Coercible::Symbol.enum(:organization, :person)

  GlobalIDURL = AppTypes::String.constrained(format: %r{\Agid://[^/]+/[^/]+/.+})

  GlobalIDType = Instance(::GlobalID) | GlobalIDURL

  GlobalIDList = AppTypes::Array.of(GlobalIDType)

  Path = Instance(::Pathname)

  Position = Coercible::Integer.constrained(gteq: 0)

  SimpleSortDirection = Coercible::String.default("asc").enum("asc", "desc").fallback("asc")

  SemanticVersion = Constructor(Semantic::Version) do |input|
    raise Dry::Types::ConstraintError.new(nil, input) if input.blank?

    Semantic::Version.new input.to_s
  rescue ArgumentError => e
    raise Dry::Types::ConstraintError.new e.message, input
  end

  GraphQLTypeClass = Inherits(Types::BaseObject)

  GraphQLEdgeClass = Inherits(GraphQL::Types::Relay::BaseEdge)

  GraphQLConnectionClass = Inherits(GraphQL::Types::Relay::BaseConnection)

  FullTextKind = AppTypes::Coercible::String.enum("text", "markdown", "html").fallback("text").constructor do |value|
    value.to_s.underscore
  end

  FullTextReference = AppTypes::Hash.schema(
    content?: AppTypes::String.optional,
    kind?: FullTextKind,
    lang?: AppTypes::String.optional,
  ).with_key_transform(&:to_sym)

  Model = Instance(ActiveRecord::Base)

  ModelList = AppTypes::Array.of(Model)

  ModelClass = Inherits(ActiveRecord::Base)

  ModelClassList = AppTypes::Array.of(ModelClass)

  CollectedReferenceMap = AppTypes::Hash.map(AppTypes::String, ModelList)

  FullTextMap = AppTypes::Hash.map(AppTypes::String, FullTextReference.optional)

  ScalarReferenceMap = AppTypes::Hash.map(AppTypes::String, Model.optional)

  SchemaURL = AppTypes::Hash.schema(
    href: AppTypes::String,
    label: AppTypes::String.default("URL"),
    title?: AppTypes::String.default("").optional,
  ).with_key_transform(&:to_sym)

  ValueHash = Instance(ActiveSupport::HashWithIndifferentAccess).constructor do |value|
    maybe_value = value.respond_to?(:to_h) ? value.to_h : value

    maybe_hash = Coercible::Hash.try maybe_value

    maybe_hash.to_monad.value_or({}).with_indifferent_access
  end

  PossibleParamTypeName = Dry::Types.container.keys.grep(/\Aparams\./).then do |types|
    unprefixed_types = types.map { |type| type.sub(/\Aparams\./, "") }

    AppTypes::Coercible::String.enum(*unprefixed_types)
  end

  PropertyType = Nominal(Dry::Types::Type).constructor do |value|
    case value
    when Dry::Types::Type then value
    when :any then Any
    when :boolean then AppTypes::Params::Bool
    when PossibleParamTypeName then Dry::Types["params.#{value}"]
    end
  end

  AnyUser = Instance(::User) | Instance(::AnonymousUser)

  class FlexibleStruct < Dry::Struct
    transform_keys(&:to_sym)

    transform_types do |type|
      if type.default?
        type.constructor do |value|
          value.nil? ? Dry::Types::Undefined : value
        end
      else
        type
      end
    end
  end
end
