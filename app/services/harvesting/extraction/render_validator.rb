# frozen_string_literal: true

module Harvesting
  module Extraction
    class RenderValidator
      extend Dry::Core::ClassAttributes

      include ActiveModel::Model
      include ActiveModel::Validations
      include Dry::Monads[:result]

      # @return [Hash]
      attr_accessor :data

      # @return [String]
      attr_accessor :output

      defines :attr_name, type: Harvesting::Types::Symbol

      attr_name :attr

      def to_monad
        if valid?
          Success()
        else
          Failure[:render_invalid, self]
        end
      end

      class << self
        def name
          "harvesting/extraction/render_validator/#{attr_name}_validator".classify
        end
      end
    end
  end
end
