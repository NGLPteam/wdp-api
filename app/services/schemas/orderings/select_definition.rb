# frozen_string_literal: true

module Schemas
  module Orderings
    class SelectDefinition
      include StoreModel::Model

      DIRECT = %w[none children descendants].freeze

      attribute :direct, :string, default: "children"
      attribute :links, Schemas::Orderings::SelectLinkDefinition.to_type, default: proc { {} }

      validates :direct, presence: true, inclusion: { in: DIRECT }

      validate :enforce_selecting_something!

      # @param [String] auth_path
      # @return [String]
      def build_auth_query_for(auth_path)
        if limit_to_single_depth?
          "#{auth_path}.*{1}"
        else
          "#{auth_path}.*{1,}"
        end
      end

      def all_descendants?
        direct == "descendants"
      end

      def children?
        direct == "children"
      end

      def no_children?
        direct == "none"
      end

      def limit_to_single_depth?
        children? || (!all_descendants? && links.any?)
      end

      def nothing?
        links.none? && no_children?
      end

      # @return [void]
      def enforce_selecting_something!
        errors.add :base, "must select something" if nothing?
      end
    end
  end
end
