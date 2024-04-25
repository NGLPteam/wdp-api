# frozen_string_literal: true

module Testing
  module SideEffects
    # @see Testing::SideEffects::Build
    class Tester < Dry::Struct
      attribute :action, Testing::Types.Interface(:call)
      attribute :effects, Testing::Types::Array.optional
      attribute :expectation, Testing::Types::Any.optional

      def has_expectation?
        !expectation.nil?
      end
    end
  end
end
