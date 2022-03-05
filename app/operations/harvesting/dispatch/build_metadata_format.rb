# frozen_string_literal: true

module Harvesting
  module Dispatch
    class BuildMetadataFormat
      include Dry::Monads[:result]
      include WDPAPI::Deps[
        jats: "harvesting.metadata.formats.jats",
        mets: "harvesting.metadata.formats.mets",
        mods: "harvesting.metadata.formats.mods",
      ]

      HAS_METADATA_FORMAT = AppTypes.Interface(:metadata_format)

      # @param [#metadata_format] formattable
      # @return [Harvesting::Metadata::BaseFormat]
      def call(formattable)
        case formattable
        when HAS_METADATA_FORMAT
          metadata_format = formattable.metadata_format

          case metadata_format
          when "jats"
            jats
          when "mets"
            mets
          when "mods"
            mods
          else
            # :nocov:
            Failure[:unknown_metadata_format, "Cannot process metadata format: #{metadata_format}"]
            # :nocov:
          end
        else
          # :nocov:
          Failure[:invalid_formatter, "Cannot derive metadata format from #{formattable.inspect}"]
          # :nocov:
        end
      end
    end
  end
end
