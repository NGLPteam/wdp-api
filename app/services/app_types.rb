# frozen_string_literal: true

module AppTypes
  include Dry.Types

  extend Shared::EnhancedTypes

  require_relative "anonymous_user"

  # @see https://www.crossref.org/blog/dois-and-matching-regular-expressions/
  DOI_PATTERN = %r|\A10\.\d{4,9}/[-._;()/:A-Z0-9]+\z|i

  ISSN_PATTERN = /\A\d{4}-\d{4}\z/

  UUID_PATTERN = /\A[0-9a-f]{8}\b-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-\b[0-9a-f]{12}\z/i

  UUID = AppTypes::String.constrained(format: UUID_PATTERN)

  EMAIL_PATTERN = URI::MailTo::EMAIL_REGEXP

  SLUG_PATTERN = /\A[a-z0-9]+(?:-[a-z0-9]+)*\z/

  URL_PATTERN = URI::DEFAULT_PARSER.make_regexp(%w[http https]).freeze

  UUIDList = Array.of(AppTypes::UUID).constrained(min_size: 1)

  EntityVisibility = Coercible::String.enum("visible", "hidden", "limited")

  IntList = AppTypes::Array.of(AppTypes::Integer)

  StringList = AppTypes::Array.of(AppTypes::String)

  DOI = String.constrained(format: DOI_PATTERN)

  CoercibleString = Coercible::String

  CoercibleStringList = AppTypes::Coercible::Array.of(AppTypes::Coercible::String)

  AttributePath = AppTypes::Array.of(AppTypes::Integer | AppTypes::Coercible::String)

  ContributorKind = AppTypes::Coercible::Symbol.enum(:organization, :person)

  ISSN = String.constrained(format: ISSN_PATTERN)

  MIME = Instance(::MIME::Type).constructor do |input|
    case input
    when "audio/mp3"
      ::MIME::Types["audio/mpeg"].first
    when ::String
      ::MIME::Types[input].first
    end
  end.fallback do
    ::MIME::Types["application/octet-stream"].first
  end

  Path = Instance(::Pathname)

  Position = Coercible::Integer.constrained(gteq: 0)

  SimpleSortDirection = Coercible::String.default("asc").enum("asc", "desc").fallback("asc")

  SemanticVersion = Constructor(Semantic::Version) do |input|
    raise Dry::Types::ConstraintError.new(nil, input) if input.blank?

    Semantic::Version.new input.to_s
  rescue ArgumentError => e
    raise Dry::Types::ConstraintError.new e.message, input
  end

  Slug = String.constrained(format: SLUG_PATTERN)

  GraphQLTypeClass = Inherits(Types::BaseObject)

  GraphQLEdgeClass = Inherits(GraphQL::Types::Relay::BaseEdge)

  GraphQLConnectionClass = Inherits(GraphQL::Types::Relay::BaseConnection)

  AnyUser = Instance(::User) | Instance(::AnonymousUser)
end
