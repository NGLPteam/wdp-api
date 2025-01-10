# frozen_string_literal: true

module Templates
  module Drops
    # A wrapper around {Community a community}.
    class CommunityDrop < Templates::Drops::AbstractEntityDrop
      entity_delegates! :tagline
    end
  end
end
