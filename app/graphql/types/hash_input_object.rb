# frozen_string_literal: true

module Types
  # @abstract For input objects that should automatically become hashes.
  class HashInputObject < Types::BaseInputObject
    # @note A graphql-ruby hook method that transforms the input object before
    #   it is sent to be processed by mutation operations.
    # @return [{ Symbol => Object }]
    def prepare
      to_h.symbolize_keys
    end
  end
end
