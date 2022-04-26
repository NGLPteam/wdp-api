# frozen_string_literal: true

module Seeding
  module Import
    module Structs
      module Collections
        class Series < Seeding::Import::Structs::Collections::Base
          attribute :schema, Seeding::Types::Value("nglp:series")

          attribute :properties, SeriesProperties.with_default
        end
      end
    end
  end
end
