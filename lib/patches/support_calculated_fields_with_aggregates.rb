# frozen_string_literal: true

module Patches
  # When you add an arel node or similar calculated field to select,
  # `relation.count` no longer works. This is a very simple fix for that.
  module SupportCalculatedFieldsWithAggregates
    extend ActiveSupport::Concern

    def select_for_count
      return :all if has_calculated_select_fields?

      super
    end

    def has_calculated_select_fields?
      select_values.any? do |value|
        value.kind_of?(Arel::Nodes::Node) || value.kind_of?(Arel::Expressions) || (value.kind_of?(String) && value.match?(/ AS /))
      end
    end
  end
end

ActiveRecord::Relation.prepend Patches::SupportCalculatedFieldsWithAggregates
