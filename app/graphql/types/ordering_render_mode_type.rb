# frozen_string_literal: true

module Types
  # @see Schemas::Orderings::RenderDefinition#mode
  class OrderingRenderModeType < Types::BaseEnum
    description <<~TEXT
    How entries in an ordering should be rendered.
    TEXT

    value "FLAT", value: "flat" do
      description <<~TEXT
      The default for most orderings. Every ordering is considered to be on
      the same level of the hierarchy, and positions are calculated based
      solely on the paths.
      TEXT
    end

    value "TREE", value: "tree" do
      description <<~TEXT
      A special mode for handling orderings that should operate like a tree. In this setting,
      entries will be calculated first as though they were flat, then analyzed in order to
      adjust the positioning to account for the entry's ancestors and position relative to
      other entries in the ordering.
      TEXT
    end
  end
end
