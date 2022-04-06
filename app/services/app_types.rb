# frozen_string_literal: true

module AppTypes
  include Dry.Types

  extend Shared::EnhancedTypes

  UUID_PATTERN = /\A[0-9a-f]{8}\b-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-\b[0-9a-f]{12}\z/i.freeze

  UUID = AppTypes::String.constrained(format: UUID_PATTERN)

  EMAIL_PATTERN = URI::MailTo::EMAIL_REGEXP

  SLUG_PATTERN = /\A[a-z0-9]+(?:-[a-z0-9]+)*\z/.freeze

  URL_PATTERN = URI::DEFAULT_PARSER.make_regexp(%w[http https]).freeze

  UUIDList = Array.of(AppTypes::UUID).constrained(min_size: 1)

  EntityVisibility = Coercible::String.enum("visible", "hidden", "limited")

  IntList = AppTypes::Array.of(AppTypes::Integer)

  StringList = AppTypes::Array.of(AppTypes::String)

  CoercibleString = Coercible::String

  CoercibleStringList = AppTypes::Coercible::Array.of(AppTypes::Coercible::String)

  AttributePath = AppTypes::Array.of(AppTypes::Integer | AppTypes::Coercible::String)

  ContributorKind = AppTypes::Coercible::Symbol.enum(:organization, :person)

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
