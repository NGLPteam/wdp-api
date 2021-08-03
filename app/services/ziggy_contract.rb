# frozen_string_literal: true

class ZiggyContract < ApplicationContract
  config.types = Schemas::Properties::SchemaTypes

  params do
    required(:tags).array(:string)

    optional(:oops).maybe(:array) do
      array? > each(:str?)
    end
  end

  rule(:tags).each(:tag_format)
end
