# frozen_string_literal: true

module Filtering
  module Scopes
    class HarvestSets < Filtering::FilterScope[HarvestSet]
      simple_filter! :identifier, :string
      simple_scope_filter! :name, :string
    end
  end
end
