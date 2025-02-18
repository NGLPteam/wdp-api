# frozen_string_literal: true

module Schemas
  module Versions
    # Options for controlling certain optional core properties that may not be used on all entities, but are specific enough to not be set as a schema property.
    #
    # @note These should be mostly ignored for {Community} schemas, when those are utilized in the future.
    # @see Schemas::Versions::Configuration#core
    class CoreDefinition
      include StoreModel::Model

      # @!attribute [rw] doi
      # Whether to expose or hide the DOI core property.
      #
      # @see https://doi.org
      # @return [Boolean]
      attribute :doi, :boolean, default: true

      # @!attribute [rw] subtitle
      # Whether to expose or hide the subtitle core property.
      # @return [Boolean]
      attribute :subtitle, :boolean, default: true
    end
  end
end
