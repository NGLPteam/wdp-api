# frozen_string_literal: true

module Types
  class MutationErrorScopeType < Types::BaseEnum
    value "GLOBAL", value: "global"
    value "ATTRIBUTE", value: "attribute"
  end
end
