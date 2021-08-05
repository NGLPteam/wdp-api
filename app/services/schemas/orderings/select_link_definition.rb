# frozen_string_literal: true

module Schemas
  module Orderings
    class SelectLinkDefinition
      include StoreModel::Model

      attribute :contains, :boolean, default: proc { false }
      attribute :references, :boolean, default: proc { false }

      def any?
        contains || references
      end

      def all?
        contains && references
      end

      def none?
        !any?
      end

      def selector
        [nil].tap do |arr|
          arr << "contains" if contains
          arr << "references" if references
        end
      end
    end
  end
end
