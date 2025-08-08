# frozen_string_literal: true

module Types
  class ListEntityContextType < Types::BaseEnum
    description <<~TEXT
    An enum used to control how much context to show for listed entities in a template.
    TEXT

    value "FULL", value: "full" do
      description <<~TEXT
      Show the maximum amount of context for listed entities.
      TEXT
    end

    value "ABBR", value: "abbr" do
      description <<~TEXT
      Show an abbreviated amount of context for listed entities.
      TEXT
    end

    value "NONE", value: "none" do
      description <<~TEXT
      Show the minimal / no amount of context for listed entities.
      TEXT
    end
  end
end
