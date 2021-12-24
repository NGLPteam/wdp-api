# frozen_string_literal: true

module Types
  class SchemaPropertyFunctionType < Types::BaseEnum
    description "Schema properties can serve various functions. This helps communicate the purpose of them, for building UIs, and general introspection."

    value "CONTENT", value: "content" do
      description <<~TEXT
      This property acts as data inherently representative of the entity. Full text of an article, titling, and other such purposes.
      TEXT
    end

    value "METADATA", value: "metadata" do
      description <<~TEXT
      This property is intended to offer further information about the content, but not necessarily the content itself.
      Most metadata should be things that are filterable or searchable to help users find and learn more about related
      content.
      TEXT
    end

    value "PRESENTATION", value: "presentation" do
      description <<~TEXT
      This property is used for presenting information *about* the content, or how it should be formatted, but is less reflective
      of the content itself. An option for changing a specific render style, an additional image to display, etc.
      TEXT
    end

    value "SORTING", value: "sorting" do
      description <<~TEXT
      This property is only used when ordering this entity by ancestors. It should not generally be visible in the frontend, but
      remain editable by admins to adjust ordering.
      TEXT
    end

    value "UNSPECIFIED", value: "unspecified" do
      description <<~TEXT
      This property's purpose remains unspecified and is likely the mark of a schema still in development. It should not generally
      be in a finished schema, as it is important to help communicate the intent of a property for those building a UI.
      TEXT
    end
  end
end
