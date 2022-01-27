# frozen_string_literal: true

module Schemas
  module Properties
    # @abstract
    class BaseReader
      extend Dry::Initializer

      include Dry::Core::Equalizer.new(:full_path)
      include Dry::Monads[:result]

      # @!attribute [r] full_path
      # @abstract
      # @return [String]

      # Test if this is a {Schemas::Properties::GroupReader group reader}.
      def group?
        kind_of? ::Schemas::Properties::GroupReader
      end

      # Test if this is a {Schemas::Properties::Reader scalar reader}.
      def scalar?
        kind_of? ::Schemas::Poperties::Reader
      end

      # @return [Dry::Monads::Result]
      def must_be_scalar
        if group?
          Failure[:group_property, "#{full_path} is a group property"]
        else
          Success self
        end
      end
    end
  end
end
