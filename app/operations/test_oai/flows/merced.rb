# frozen_string_literal: true

module TestOAI
  module Flows
    class Merced
      include WDPAPI::Deps[
        workflow: "test_oai.workflow"
      ]

      def call
        args = {
          community_options: {
            title: "UC Merced"
          },
          source_options: {
            identifier: "merced",
            name: "UC Merced OAI Test",
            protocol: "oai",
            metadata_format: "mets",
            base_url: "https://dspace-pilot.escholarship.org/server/oai/request",
          },
          on_community: true
        }

        workflow.call args
      end
    end
  end
end
