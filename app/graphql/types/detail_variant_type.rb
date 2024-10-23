# frozen_string_literal: true

module Types
  class DetailVariantType < Types::BaseEnum
    description <<~TEXT
    An enumerated value associated with the templating subsystem.
    TEXT

    value "FULL", value: "full" do
      description <<~TEXT
      TEXT
    end

    value "SUMMARY", value: "summary" do
      description <<~TEXT
      TEXT
    end
  end
end
