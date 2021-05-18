# frozen_string_literal: true

module AppTypes
  include Dry.Types

  UUID_PATTERN = /\A[0-9a-f]{8}\b-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-\b[0-9a-f]{12}\z/i.freeze

  UUID = AppTypes::String.constrained(format: UUID_PATTERN)

  IntList = AppTypes::Array.of(AppTypes::Integer)

  StringList = AppTypes::Array.of(AppTypes::String)

  JWTIssuer = (AppTypes::String | StringList).optional

  ContributorKind = AppTypes::Coercible::Symbol.enum(:organization, :person)

  class << self
    def Implements(mod)
      AppTypes::Class.constrained(lt: mod)
    end

    alias Inherits Implements

    def InstanceOrClass(mod)
      instance = Instance(mod)
      klass = Implements(mod)

      instance | klass
    end
  end

  GraphQLTypeClass = Inherits(Types::BaseObject)

  GraphQLEdgeClass = Inherits(GraphQL::Types::Relay::BaseEdge)

  GraphQLConnectionClass = Inherits(GraphQL::Types::Relay::BaseConnection)

  ModelClass = Inherits(ApplicationRecord)

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
