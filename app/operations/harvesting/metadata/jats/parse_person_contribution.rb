# frozen_string_literal: true

module Harvesting
  module Metadata
    module JATS
      class ParsePersonContribution
        include Dry::Monads[:result]
        include Harvesting::Metadata::XMLExtraction

        error_context :contribution_parsing

        default_namespace! Namespaces[:jats]

        extract_values! do
          value :corresp, type: :bool, require_match: false do
            xpath "./@corresp" do
              pipeline! do
                xml_text

                equals("yes")
              end
            end

            attribute :default_corresp
          end

          xpath :email, "./xmlns:email/text()", type: :present_string, require_match: false

          xpath_list :given_name, "./xmlns:name/xmlns:given-names/text()", type: :present_string do
            pipeline! do
              map_array do
                xml_text
              end

              join_array " "
            end
          end

          xpath_list :family_name, "./xmlns:name/xmlns:surname/text()", type: :present_string

          xpath :rid, %,./xmlns:xref[@ref-type="aff"][@rid]/@rid,, type: :present_string, require_match: false

          value :affiliation, type: :present_string, require_match: false do
            depends_on :rid

            xpath "./ancestor::xmlns:article-meta" do
              pipeline! do
                get_with_xpath %,.//xmlns:aff[@id="%1$s"],, :rid

                get_with_xpath "./xmlns:institution/text()"

                xml_text
              end
            end

            xpath "./ancestor::xmlns:article-meta" do
              pipeline! do
                get_with_xpath %,.//xmlns:aff[@id="%1$s"],, :rid

                get_with_xpath "./text()"

                xml_text
              end
            end
          end

          value :role, type: :present_string do
            xpath "./@contrib-type"

            xpath "./xmlns:role/text()"

            xpath "./parent::xmlns:contrib-group/@content-type"
          end

          on_struct do
            # @return [Hash]
            def to_contribution
              contributor = {
                kind: :person,
                attributes: {
                  email: email,
                },
                properties: {
                  given_name: given_name,
                  family_name: family_name,
                  affiliation: affiliation,
                }
              }

              {
                kind: role,
                metadata: {
                  "rid" => rid,
                  affiliation: affiliation,
                  corresp: corresp,
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

        def default_corresp
          false
        end
      end
    end
  end
end
