# frozen_string_literal: true

module Entities
  class DOIData
    include Support::EnhancedStoreModel

    # Whether this doi data corresponds to what is expected by crossref.
    attribute :crossref, :boolean, default: false

    # The actual DOI value (sans URL).
    attribute :doi, :string

    # The host (should be doi.org, but can be others)
    attribute :host, :string

    # Whether this glob of data should be considered valid
    attribute :ok, :boolean, default: false

    # The full URL (if available).
    attribute :url, :string
  end
end
