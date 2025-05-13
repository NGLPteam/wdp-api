# frozen_string_literal: true

module Harvesting
  module Metadata
    module JATS
      class PubDateDrop < Harvesting::Metadata::JATS::AbstractDateDrop
        data_attrs! :publication_format, type: :string

        after_initialize :extract_pub!

        # @return [Boolean]
        attr_reader :pub

        alias pub? pub

        private

        # @return [void]
        def extract_pub!
          @pub = @data.date_type == "pub"
        end
      end
    end
  end
end
