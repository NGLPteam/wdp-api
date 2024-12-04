# frozen_string_literal: true

module Templates
  module Tags
    # Refinements used by tags to gain access to private variables
    # within drops that must not be directly accessible within the
    # Liquid context.
    module DropAccess
      refine ::Templates::Drops::AbstractEntityDrop do
        # @return [HierarchicalEntity]
        attr_reader :entity
      end

      refine ::Templates::Drops::AncestorsDrop do
        # @return [HierarchicalEntity]
        attr_reader :entity
      end

      refine ::Templates::Drops::AssetDrop do
        # @return [Asset]
        attr_reader :asset
      end

      refine ::Templates::Drops::PropertyValueDrop do
        def asset
          # :nocov:
          @value if @type == "asset"
          # :nocov:
        end

        def entity
          # :nocov:
          @value if @type == "entity"
          # :nocov:
        end
      end
    end
  end
end
