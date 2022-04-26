# frozen_string_literal: true

module Seeding
  module Import
    module Structs
      module Collections
        AnyList = Seeding::Types::Coercible::Array.constructor do |arr|
          Array(arr).map do |collection|
            Seeding::Import::Structs::Collections::Any[collection]
          end
        end.default { [] }
      end
    end
  end
end
