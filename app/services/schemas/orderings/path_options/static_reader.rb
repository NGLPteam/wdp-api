# frozen_string_literal: true

module Schemas
  module Orderings
    module PathOptions
      class StaticReader < Reader
        param :property, Schemas::Orderings::Types.Instance(StaticOrderableProperty)

        delegate :grouping, :path, :label, :description, :type, to: :property
      end
    end
  end
end
