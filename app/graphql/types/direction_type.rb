# frozen_string_literal: true

module Types
  class DirectionType < Types::BaseEnum
    value "ASCENDING", value: "asc"
    value "DESCENDING", value: "desc"
  end
end
