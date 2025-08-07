# frozen_string_literal: true

module Patches
  # A patch to force the `active_record_distinct_on` to respect existing
  # arel attributes and simply use them instead of trying to cast them.
  module DistinctOnSupportArel
    extend ActiveSupport::Concern

    include ActiveRecordDistinctOn::DistinctOnQueryMethods

    def build_distinct_on_field(klass, field)
      case field
      when Arel::Expressions, Arel::Nodes::Node, Arel::Attribute
        field
      else
        super
      end
    end
  end
end

ActiveRecord::Relation.prepend Patches::DistinctOnSupportArel
