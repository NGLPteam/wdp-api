# frozen_string_literal: true

module Templates
  module Drops
    # A wrapper around {Item an item}.
    class ItemDrop < Templates::Drops::AbstractEntityDrop
      entity_delegates! :doi, :issn
    end
  end
end
