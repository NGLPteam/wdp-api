# frozen_string_literal: true

module Seeding
  module Import
    module Structs
      module Collections
        class Journal < Seeding::Import::Structs::Collections::Base
          attribute :schema, Seeding::Types::Value("nglp:journal")

          attribute :properties, JournalProperties.with_default
        end
      end
    end
  end
end
