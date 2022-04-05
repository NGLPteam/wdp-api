# frozen_string_literal: true

module Harvesting
  module Metadata
    module JATS
      class ParseOrganizationContribution
        include Dry::Monads[:result]
        include Harvesting::Metadata::XMLExtraction

        error_context :contribution_parsing

        default_namespace! Namespaces[:jats]

        extract_values! do
          xpath :id, "./@id", type: :present_string

          value :legal_name, type: :present_string do
            xpath "./xmlns:institution/text()"

            xpath "./text()"
          end

          on_struct do
            # @return [Hash]
            def to_contribution
              contributor = {
                kind: :organization,
                attributes: {},
                properties: {
                  legal_name: legal_name
                }
              }

              {
                kind: "affiliated_institution",
                metadata: {
                  "aff_id" => id,
                },
                contributor: contributor
              }
            end
          end
        end

        def call(element)
          with_element element do
            extract_values
          end.fmap(&:to_contribution).or do
            Success(nil)
          end
        end
      end
    end
  end
end
