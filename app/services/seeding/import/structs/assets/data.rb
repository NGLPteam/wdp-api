# frozen_string_literal: true

module Seeding
  module Import
    module Structs
      module Assets
        # @todo Implement later when necessary
        class Data < Seeding::Import::Structs::Assets::Base
          attribute :format, Seeding::Types::Value("data")
          attribute :data, Seeding::Types::String
        end
      end
    end
  end
end
