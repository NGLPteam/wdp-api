# frozen_string_literal: true

module Types
  class DescendantListVariantType < Types::BaseEnum
    description <<~TEXT
    An enumerated value associated with the templating subsystem.
    TEXT

    value "CARDS", value: "cards" do
      description <<~TEXT
      A card list of entities.
      TEXT
    end

    value "COMPACT", value: "compact" do
      description <<~TEXT
      A compact list of entities.
      TEXT
    end

    value "GRID", value: "grid" do
      description <<~TEXT
      A grid of entities
      TEXT
    end

    value "PROMOS", value: "promos" do
      description <<~TEXT
      A horizontal list of entities with promotional header.
      TEXT
    end

    value "SUMMARY", value: "summary" do
      description <<~TEXT
      A vertical, summarized list of entities.
      TEXT
    end
  end
end
