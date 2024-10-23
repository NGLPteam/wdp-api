# frozen_string_literal: true

module Schemas
  module Mappers
    # A scalar type that represents a semantic version (or range of such).
    class VersionRequirement < Shale::Type::Value
      TYPE = ::GlobalTypes::VersionRequirement.new

      class << self
        # @see ::GlobalTypes::VersionRequirement
        # @param [#to_s]
        # @return [Gem::Requirement]
        def cast(value)
          TYPE.cast(value)
        end
      end
    end
  end
end
