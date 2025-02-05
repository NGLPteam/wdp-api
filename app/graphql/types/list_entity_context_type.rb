# frozen_string_literal: true

module Types
  class ListEntityContextType < Types::BaseEnum
    description <<~TEXT
    An enumerated value associated with the templating subsystem.
    TEXT

    value "FULL", value: "full" do
      description <<~TEXT
      TEXT
    end

    value "ABBR", value: "abbr" do
      description <<~TEXT
      TEXT
    end

    value "NONE", value: "none" do
      description <<~TEXT
      TEXT
    end
  end
end
