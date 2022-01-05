# frozen_string_literal: true

module Schemas
  module Orderings
    # Options for controlling how to render {OrderingEntry entries} in an {Ordering}.
    class RenderDefinition
      include StoreModel::Model

      # @api private
      MODE_MAP = %i[flat tree].index_with(&:to_s).freeze

      # @!attribute [rw] mode
      # @note `:tree` has some special handling and greatly alters how orderings are calculated
      #   as well as how selection works. Setting an ordering to `tree` effectively means
      #   `select.direct` is set to `descendants`.
      # @return [:flat, :tree]
      enum :mode, in: MODE_MAP, default: :flat, _suffix: :mode
    end
  end
end
