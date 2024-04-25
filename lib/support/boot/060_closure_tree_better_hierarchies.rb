# frozen_string_literal: true

module Patches
  module ClosureTree
    module BetterHierarchies
      def hierarchy_class_for_model
        parent_class = ActiveSupport::VERSION::MAJOR >= 6 ? model_class.module_parent : model_class.parent

        if parent_class.const_defined?(short_hierarchy_class_name)
          hierarchy_class = parent_class.const_get(short_hierarchy_class_name)

          unless hierarchy_class < ::ClosureTreeHierarchy
            raise TypeError, "Expected #{hierarchy_class} to implement `ClosureTreeHierarchy`"
          end

          return hierarchy_class
        end

        super
      end
    end
  end
end

ClosureTree::Support.prepend Patches::ClosureTree::BetterHierarchies
