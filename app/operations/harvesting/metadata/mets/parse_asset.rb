# frozen_string_literal: true

module Harvesting
  module Metadata
    module METS
      # Parse assets into structs from `METS` metadata, grabbing
      # some values from nested `PREMIS` data.
      class ParseAsset
        include Harvesting::Metadata::XMLExtraction
        include Dry::Effects.Resolve(:premis_items)
        include Dry::Monads[:result]
        include Dry::Monads::Do.for(:call)

        error_context :asset_parsing

        add_xlink!

        default_namespace! Namespaces[:mets]

        extract_values! do
          attribute :premis_items, :premis_items, type: :extracted_value_map

          xpath :identifier, ".//@ID", type: :present_string
          xpath :mime_type, ".//@MIMETYPE", type: :present_string
          xpath :wrapper_id, ".//@ADMID", type: :present_string, require_match: false
          xpath :sequence, ".//@SEQ", type: :integer, require_match: false
          xpath :file_size, ".//@SIZE", type: :integer, require_match: false
          xpath :checksum, ".//@CHECKSUM", type: :string, require_match: false
          xpath :checksum_type, ".//@CHECKSUMTYPE", type: :string, require_match: false
          xpath :logical_id, ".//@GROUPID", type: :string, require_match: false
          xpath :use, ".//ancestor::xmlns:fileGrp[@USE]/@USE", type: :string, require_match: false

          set :location do
            xpath :type, ".//xmlns:FLocat/@LOCTYPE", type: :string
            xpath :link_type, ".//xmlns:FLocat/@xlink:type", type: :string, require_match: false
            xpath :url, ".//xmlns:FLocat/@xlink:href", type: :url

            on_struct do
              def url?
                type == "URL"
              end
            end
          end

          compose_value :premis, from: :wrapper_id, type: :extracted_values do
            depends_on :premis_items

            pipeline! do
              fetch_from_dependency :premis_items
            end
          end

          on_struct do
            delegate :original_filename, to: :premis

            alias_method :name, :original_filename

            def schema_property?
              original_pdf? || text_version?
            end

            def original?
              use == "ORIGINAL"
            end

            def original_pdf?
              original? && pdf?
            end

            def pdf?
              mime_type == "application/pdf"
            end

            def text?
              mime_type == "text/plain"
            end

            def text_version?
              use == "TEXT" && text?
            end

            # A tuple for use with {Harvesting::Entities::Assigner}
            #
            # @return [(String, String, Hash)]
            def to_assigner
              [identifier, location.url, { name: name, mime_type: mime_type }]
            end

            def unassociated?
              !schema_property?
            end

            def video?
              mime_type =~ %r{\Avideo/}
            end
          end
        end

        # @param [Nokogiri::XML::Element] element
        # @return [Dry::Monads::Result]
        def call(element)
          with_element element do
            yield validate_file_location!

            extract_values
          end
        end

        private

        # @return [Dry::Monads::Result(void)]
        def validate_file_location!
          flocat = at_xpath(%{.//xmlns:FLocat[@LOCTYPE="URL"]})

          return Success() if flocat.present?

          extraction_error!(:unsupported_file_location, message: "We only support files with a URL location at present.")
        end
      end
    end
  end
end
