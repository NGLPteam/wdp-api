# frozen_string_literal: true

module Harvesting
  module Extraction
    module Mappings
      module Props
        # @abstract
        class AbstractSet < Harvesting::Extraction::Mappings::Abstract
          defines :prop_attrs, type: Harvesting::Extraction::Types::SymbolList
          defines :prop_klasses, type: Harvesting::Extraction::Types::Array.of(Harvesting::Extraction::Types::Class)

          prop_attrs EMPTY_ARRAY
          prop_klasses EMPTY_ARRAY

          # @return [{ String => Harvesting::Extraction::Mappings::Props::Base }]
          def to_prop_set
            self.class.prop_attrs.reduce([]) do |props, prop_attr|
              props.concat(__send__(prop_attr))
            end.uniq(&:path).index_by(&:path)
          end

          class << self
            def accept_props!(klass)
              prop_attr = klass.property_attr

              attribute prop_attr, klass, collection: true, default: -> { [] }

              prop_attrs prop_attrs | [prop_attr]
              prop_klasses prop_klasses | [klass]
            end
          end
        end
      end
    end
  end
end
