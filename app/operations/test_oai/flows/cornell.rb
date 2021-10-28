# frozen_string_literal: true

module TestOAI
  module Flows
    class Cornell
      include WDPAPI::Deps[
        workflow: "test_oai.workflow",
      ]

      TEST_SET_IDS = %w[col_1813_8186 col_1813_3764 col_1813_30919 col_1813_72695].freeze

      def call
        args = {
          community_options: {
            title: "Cornell Testing",
          },
          source_options: {
            name: "Cornell DSpace",
            protocol: "oai",
            metadata_format: "mods",
            base_url: "https://ecommons.cornell.edu/oai/request",
          },
          set_identifiers: TEST_SET_IDS
        }

        workflow.call args
      end
    end
  end
end
