# frozen_string_literal: true

module Templates
  module Drops
    # A wrapper around {Collection a collection}.
    class CollectionDrop < Templates::Drops::AbstractEntityDrop
      entity_delegates! :doi, :issn
    end
  end
end
