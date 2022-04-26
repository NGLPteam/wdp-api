# frozen_string_literal: true

module Seeding
  module Import
    module Structs
      module Collections
        class Default < Seeding::Import::Structs::Collections::Base
          attribute :schema, Seeding::Types::Value("default:collection")
        end
      end
    end
  end
end
