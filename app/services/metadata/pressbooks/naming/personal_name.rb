# frozen_string_literal: true

module Metadata
  module Pressbooks
    module Naming
      class PersonalName
        include ActiveModel::Validations
        include Dry::Core::Constants
        include Dry::Initializer[undefined: false].define -> do
          option :input, Metadata::Types::String.optional, optional: true
          option :parsed, Metadata::Types::NamaeValues, default: proc { EMPTY_ARRAY }
          option :matched, Metadata::Types::NamaeValue.optional, default: proc { parsed.first }
          option :given, Metadata::Types::String.optional, default: proc { matched&.given&.to_s&.strip }
          option :family, Metadata::Types::String.optional, default: proc { matched&.family&.to_s&.strip }
        end

        validates :given, :family, presence: true

        def display_name
          input.presence || "#{family}, #{given}"
        end

        class << self
          # @param [String] input
          # @return [Metadata::Pressbooks::Naming::PersonalName]
          def parse(input)
            parsed = Namae.parse(input)

            new(input:, parsed:)
          end
        end
      end
    end
  end
end
