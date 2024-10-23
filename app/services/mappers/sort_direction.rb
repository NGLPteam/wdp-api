# frozen_string_literal: true

module Mappers
  class SortDirection < Mappers::AbstractDryType
    accepts_type! ::Support::GlobalTypes::SimpleSortDirection
  end
end
