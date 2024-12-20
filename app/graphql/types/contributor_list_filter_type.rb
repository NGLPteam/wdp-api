# frozen_string_literal: true

module Types
  class ContributorListFilterType < Types::BaseEnum
    description <<~TEXT
    An enumerated value associated with the templating subsystem.
    TEXT

    value "ALL", value: "all" do
      description <<~TEXT
      Show all contributors, regardless of role.
      TEXT
    end

    value "AUTHORS", value: "authors" do
      description <<~TEXT
      Show only authors.
      TEXT
    end
  end
end
