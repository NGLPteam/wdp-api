# frozen_string_literal: true

module Types
  class FullTextKindType < Types::BaseEnum
    description "It is necessary for the system to know what kind the content is in order to properly index it"

    value "HTML", value: "html"
    value "MARKDOWN", value: "markdown"
    value "TEXT", value: "text"
  end
end
