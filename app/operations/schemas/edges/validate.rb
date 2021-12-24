# frozen_string_literal: true

module Schemas
  module Edges
    class Validate
      include Dry::Monads[:result]
      include WDPAPI::Deps[
        calculate: "schemas.edges.calculate"
      ]
      include Dry::Matcher.for(:call, with: Schemas::Edges::Matcher)

      # @see Schemas::Edges::Matcher
      # @param [String, Object] parent (@see Schemas::Types::Kind)
      # @param [String, Object] child (@see Schemas::Types::Kind)
      def call(parent, child)
        calculate.call(parent, child)
      rescue Schemas::Edges::Incomprehensible => e
        Failure[:incomprehensible, e]
      end
    end
  end
end
