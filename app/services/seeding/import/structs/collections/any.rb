# frozen_string_literal: true

module Seeding
  module Import
    module Structs
      module Collections
        # A sum type that matches any asset struct.
        Any = Series | Unit | Journal | Default
      end
    end
  end
end
