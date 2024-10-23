# frozen_string_literal: true

module Types
  class SelectionSourceModeType < Types::BaseEnum
    description <<~TEXT
    An enumerated value associated with the templating subsystem.
    TEXT

    value "SELF", value: "self" do
      description <<~TEXT
      TEXT
    end

    value "ANCESTOR", value: "ancestor" do
      description <<~TEXT
      TEXT
    end
  end
end
