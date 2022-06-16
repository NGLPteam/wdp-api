# frozen_string_literal: true

module Harvesting
  module Metadata
    module OAIDC
      # A proxy for an asset that can be a scalar property or
      # be collected elsewhere.
      class AssetProxy
        include Dry::Initializer[undefined: false].define -> do
          param :url, AppTypes::String.constrained(http_uri: true)
          param :format, AppTypes::MIME

          option :position, AppTypes::Integer, default: proc { 1 }
        end
        include Dry::Core::Memoizable

        memoize def identifier
          name.dasherize
        end

        memoize def name
          if audio?
            "Audio Version"
          elsif pdf?
            "PDF"
          else
            # :nocov:
            "Asset #{position}"
            # :nocov:
          end
        end

        def audio?
          format.media_type == "audio"
        end

        def has_specific_purpose?
          pdf?
        end

        def pdf?
          format.sub_type == "pdf"
        end

        # A tuple for use with {Harvesting::Entities::Assigner}
        #
        # @return [(String, String, Hash)]
        def to_assigner
          [identifier, url, { name: name, mime_type: format.to_s }]
        end

        def unassociated?
          !has_specific_purpose?
        end
      end
    end
  end
end
