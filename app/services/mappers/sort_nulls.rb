# frozen_string_literal: true

module Mappers
  class SortNulls < Mappers::AbstractDryType
    accepts_type! ::Mappers::Types::Nulls
  end
end
