# frozen_string_literal: true

module Schemas
  module Properties
    # A union type that dispatches betweeen all the possible types
    #
    # @see Schemas::Properties::Scalar::Base
    ScalarDefinition = StoreModel.one_of do |json|
      case json.fetch(:type, json["type"])
      when "asset" then Schemas::Properties::Scalar::Asset
      when "assets" then Schemas::Properties::Scalar::Assets
      when "boolean" then Schemas::Properties::Scalar::Boolean
      when "contributor" then Schemas::Properties::Scalar::Contributor
      when "contributors" then Schemas::Properties::Scalar::Contributors
      when "date" then Schemas::Properties::Scalar::Date
      when "email" then Schemas::Properties::Scalar::Email
      when "float" then Schemas::Properties::Scalar::Float
      when "integer" then Schemas::Properties::Scalar::Integer
      when "markdown" then Schemas::Properties::Scalar::Markdown
      when "multiselect" then Schemas::Properties::Scalar::Multiselect
      when "select" then Schemas::Properties::Scalar::Select
      when "string" then Schemas::Properties::Scalar::String
      when "tags" then Schemas::Properties::Scalar::Tags
      when "timestamp" then Schemas::Properties::Scalar::Timestamp
      else
        # :nocov:
        Schemas::Properties::Scalar::Unknown
        # :nocov:
      end
    end

    class << ScalarDefinition
      # Expose the block so it can be reused
      attr_reader :block
    end
  end
end