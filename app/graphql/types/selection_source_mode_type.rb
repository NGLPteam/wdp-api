# frozen_string_literal: true

module Types
  class SelectionSourceModeType < Types::BaseEnum
    description <<~TEXT
    An enumerated value associated with the templating subsystem.
    TEXT

    value "SELF", value: "self" do
      description <<~TEXT
      Selections should inherit from the exact entity in question
      TEXT
    end

    value "ANCESTOR", value: "ancestor" do
      description <<~TEXT
      Selections should inherit from a named ancestor of this entity.
      TEXT
    end

    value "PARENT", value: "parent" do
      description <<~TEXT
      Selections should inherit from the hierarchical parent of this entity.
      TEXT
    end
  end
end
