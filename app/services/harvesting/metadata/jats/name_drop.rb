# frozen_string_literal: true

module Harvesting
  module Metadata
    module JATS
      class NameDrop < Harvesting::Metadata::JATS::AbstractJATSDrop
        after_initialize :extract_properties!

        # @note e.g. "western"
        # @return [String]
        attr_reader :name_style

        # @return [String]
        attr_reader :surname

        alias family_name surname

        alias last_name surname

        # @return [String]
        attr_reader :given_name

        alias given_names given_name

        alias first_name given_name

        private

        # @return [void]
        def extract_properties!
          @name_style = @data.name_style || "western"

          @surname = @data.surname.content

          @given_name = @data.given_names.content
        end
      end
    end
  end
end
