# frozen_string_literal: true

module Metadata
  module Shared
    module Drops
      # Ensures auto-generated with certain attributes (`content` by default) can
      # automatically stringify themselves when rendering in a string context.
      module StringCoercion
        extend ActiveSupport::Concern

        included do
          defines :string_coercion_attribute, type: ::Metadata::Types::Symbol

          string_coercion_attribute :content
        end

        # @return [String]
        def to_s
          __send__(self.class.string_coercion_attribute).to_s
        end
      end
    end
  end
end
