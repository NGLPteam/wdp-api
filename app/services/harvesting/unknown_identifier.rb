# frozen_string_literal: true

module Harvesting
  # An error that is raised when trying to find a specific harvesting model
  # with an identifier that does not exist.
  #
  # @abstract
  # @note We distinguish from the normal pattern of `ActiveRecord::RecordNotFound`
  #   because we want special handling
  class UnknownIdentifier < Harvesting::Error
    extend Dry::Core::ClassAttributes

    # @return [String]
    attr_reader :identifier

    # @!attribute [r] model_type
    # @!scope class
    # @return [String]
    defines :model_type, type: Dry::Types["coercible.string"]

    model_type "harvest model"

    delegate :model_type, to: :class

    # @param [String] identifier
    def initialize(identifier)
      @identifier = identifier

      super("Unable to find #{model_type} by identifier: #{identifier.inspect}")
    end
  end
end
