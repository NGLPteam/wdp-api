# frozen_string_literal: true

module Schemas
  module Versions
    # Options for controlling how to render instances of this schema in isolated contexts, outside of {Ordering orderings}.
    #
    # @see Schemas::Versions::Configuration#render
    class RenderDefinition
      include StoreModel::Model

      # @api private
      LIST_MODE_MAP = %i[grid table tree].index_with(&:to_s).freeze

      # @!attribute [rw] list_mode
      # How instances that implement this schema should be rendered outside
      # of an ordering, when showing only entities of the same type.
      # @return [:grid, :table, :tree]
      enum :list_mode, in: LIST_MODE_MAP, default: :grid, _suffix: :list_mode
    end
  end
end
