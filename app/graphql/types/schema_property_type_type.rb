# frozen_string_literal: true

module Types
  class SchemaPropertyTypeType < Types::BaseEnum
    description "The data type for a schema property."

    value "ASSET", value: "asset", description: "A reference to a single asset owned by the schema instance. See `AssetProperty`"
    value "ASSETS", value: "assets", description: "A reference to multiple assets owned by the schema instance. See `AssetsProperty`"
    value "BOOLEAN", value: "boolean", description: "True or false, yes or no, a checkbox. See `BooleanProperty`"
    value "CONTRIBUTOR", value: "contributor", description: "A reference to a single contributor in the system. See `ContributorProperty`"
    value "CONTRIBUTORS", value: "contributors", description: "A reference to multiple contributors in the system. See `ContributorsProperty`"
    value "DATE", value: "date", description: "An ISO8601-formatted date. See `DateProperty`"
    value "EMAIL", value: "email", description: "An email address. See `EmailProperty`"
    value "ENTITIES", value: "entities", description: "A reference to multiple entities. See `EntitiesProperty`"
    value "ENTITY", value: "entity", description: "A reference to a single entity. See `EntityProperty`"
    value "FLOAT", value: "float", description: "A decimal / floating-point number. See `FloatProperty`"
    value "FULL_TEXT", value: "full_text", description: "A complex type representing textual content. See `FullTextProperty`"
    value "GROUP", value: "group", description: "A type composed of other properties. See `GroupProperty`"
    value "INTEGER", value: "integer", description: "A whole number. See `IntegerProperty`"
    value "MARKDOWN", value: "markdown", description: "Markdown-formatted text. See `MarkdownProperty`"
    value "MULTISELECT", value: "multiselect", description: "A dropdown that supports selecting multiple values. See `MultiselectProperty`"
    value "SELECT", value: "select", description: "A dropdown that can select only one value. See `SelectProperty`"
    value "STRING", value: "string", description: "Simple text values. See `StringProperty`"
    value "TAGS", value: "tags", description: "An array of tags that can be introspected. See `TagsProperty`"
    value "TIMESTAMP", value: "timestamp", description: "An ISO8601-formatted timestamp. See `TimestampProperty`"
    value "UNKNOWN", value: "unknown", description: "A fallback type for invalid schemas. See `UnknownProperty`"
    value "URL", value: "url", description: "A complex type representing a URL, with metadata. See `URLProperty`"
    value "VARIABLE_DATE", value: "variable_date" do
      description "A complex type representing a date that cannot be expressed exactly. See `VariableDateProperty`"
    end
  end
end
