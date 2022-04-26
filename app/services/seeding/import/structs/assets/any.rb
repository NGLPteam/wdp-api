# frozen_string_literal: true

module Seeding
  module Import
    module Structs
      module Assets
        # A sum type that matches any asset struct.
        Any = URL | Data
      end
    end
  end
end
