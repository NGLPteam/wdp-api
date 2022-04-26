# frozen_string_literal: true

module Seeding
  module Import
    module Structs
      module Assets
        class URL < Seeding::Import::Structs::Assets::Base
          attribute :format, Seeding::Types::Value("url")
          attribute :url, Seeding::Types::String.constrained(http_uri: true)
        end
      end
    end
  end
end
