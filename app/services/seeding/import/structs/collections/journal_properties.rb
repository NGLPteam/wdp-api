# frozen_string_literal: true

module Seeding
  module Import
    module Structs
      module Collections
        class JournalProperties < Seeding::Import::Structs::Properties
          attribute? :issn, Seeding::Types::String.optional
          attribute? :cc_license, Seeding::Types::String.optional
          attribute? :description, FullText::Types::NormalizedReference
          attribute :open_access, Seeding::Types::DefaultFalse
          attribute :peer_reviewed, Seeding::Types::DefaultFalse
        end
      end
    end
  end
end
