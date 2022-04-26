# frozen_string_literal: true

module Seeding
  module Import
    module Structs
      class CommunityProperties < Properties
        attribute? :featured, Properties do
          attribute? :journals, Seeding::Types::IdentifierPaths
          attribute? :series, Seeding::Types::IdentifierPaths
          attribute? :issue, Seeding::Types::IdentifierPath
          attribute? :units, Seeding::Types::IdentifierPaths
        end
      end
    end
  end
end
