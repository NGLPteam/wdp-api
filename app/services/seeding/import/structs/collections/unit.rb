# frozen_string_literal: true

module Seeding
  module Import
    module Structs
      module Collections
        class Unit < Seeding::Import::Structs::Collections::Base
          attribute :schema, Seeding::Types::Value("nglp:unit")

          attribute :properties, UnitProperties.with_default
        end
      end
    end
  end
end
