# frozen_string_literal: true

module Types
  class DetailVariantType < Types::BaseEnum
    description <<~TEXT
    An enum used to control how a detail template should be rendered.
    TEXT

    value "FULL", value: "full" do
      description <<~TEXT
      Display 'full' detail about the entity.
      TEXT
    end

    value "SUMMARY", value: "summary" do
      description <<~TEXT
      Display detail about the entity in a summarized fashion.
      TEXT
    end

    value "COLUMNS", value: "columns" do
      description <<~TEXT
      A columnar display format for entity details, similar to metadata.

      It will make use of the `items*` slots in order to render the content.

      See the `hideMetadata` property on the navigation template for an
      optimal use case with moving metadata from its own tab over to the
      main layout.
      TEXT
    end
  end
end
