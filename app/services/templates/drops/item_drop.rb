# frozen_string_literal: true

module Templates
  module Drops
    # A wrapper around {Item an item}.
    #
    # @abstract
    class ItemDrop < Templates::Drops::AbstractEntityDrop
      delegate :doi, :issn, to: :@entity
    end
  end
end
