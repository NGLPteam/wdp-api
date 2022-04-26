# frozen_string_literal: true

module Seeding
  module Import
    module Structs
      module Collections
        class SeriesProperties < Seeding::Import::Structs::Properties
          attribute? :about, Seeding::Types::String.optional
        end
      end
    end
  end
end
