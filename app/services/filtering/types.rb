# frozen_string_literal: true

module Filtering
  module Types
    include Dry.Types

    extend Shared::EnhancedTypes

    Filters = Instance(Filtering::FilterScope)

    FiltersClass = Inherits(Filtering::FilterScope)

    Input = Hash.fallback { {}.freeze }

    Scope = Instance(ActiveRecord::Relation)
  end
end
