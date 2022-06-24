# frozen_string_literal: true

module Schemas
  module Orderings
    # Configuration options to inform an {Ordering} what depth
    # to select to as well as whether or not to include any
    # links in the resulting {OrderingEntry entry set}.
    class SelectDefinition
      include StoreModel::Model

      # The available options for {#direct}.
      DIRECT = %w[none children descendants].freeze

      private_constant :DIRECT

      # @!attribute [rw] direct
      # Select the depth of children to retrieve.
      #
      # @note If this ordering is {Schemas::Orderings::RenderDefinition#mode in tree mode},
      #   that takes precedence and this option will be ignored. Instead, this class will
      #   act as though it is set to `"descendants"`.
      # @return ["none", "children", "descendants"]
      attribute :direct, :string, default: "children"

      # @!attribute [r] links
      # The configuration for selecting links.
      # @return [Schemas::Orderings::SelectLinkDefinition]
      attribute :links, Schemas::Orderings::SelectLinkDefinition.to_type, default: proc { {} }

      validates :direct, presence: true, inclusion: { in: DIRECT }

      validate :enforce_selecting_something!

      delegate :tree_mode?, to: :parent, allow_nil: true

      # @param [String] auth_path
      # @return [<String>]
      def build_auth_query_for(auth_path)
        [].tap do |queries|
          if limit_to_single_depth?
            queries << "#{auth_path}.*{1}"
            queries << "#{auth_path}._.*{1}" if links.any?
          else
            queries << "#{auth_path}.*{1,}"
          end
        end
      end

      def all_descendants?
        tree_mode? || direct == "descendants"
      end

      def children?
        !tree_mode? && direct == "children"
      end

      def no_children?
        !tree_mode? && direct == "none"
      end

      def limit_to_single_depth?
        return false if tree_mode?

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
