# frozen_string_literal: true

module TestOAI
  module Flows
    class JournalTest
      include WDPAPI::Deps[
        workflow: "test_oai.workflow"
      ]

      def call
        args = {
          community_options: {
            title: "JATS Testing"
          },
          source_options: {
            identifier: "cjhe",
            name: "SFU CJHE",
            protocol: "oai",
            metadata_format: "jats",
            base_url: "https://journals.sfu.ca/cjhe/index.php/cjhe/oai",
          },
          single_collection: {
            identifier: "cjhe",
            title: "Canadian Journal of Higher Education",
            schema_version: "nglp:journal",
          }
        }

        workflow.call args
      end
    end
  end
end
