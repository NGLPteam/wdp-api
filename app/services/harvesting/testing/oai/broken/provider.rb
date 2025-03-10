# frozen_string_literal: true

module Harvesting
  module Testing
    module OAI
      module Broken
        class Provider < ::OAI::Provider::Base
          ENDPOINT = "http://broken.oai.example.com/request"

          repository_name "Broken OAI Provider"

          record_prefix "meru:oai:broken"

          repository_url ENDPOINT

          source_model Harvesting::Testing::OAI::Broken::Model.new

          # @!attribute [r] rack_app
          # @return [Harvesting:Testing::OAI::RackWrapper]
          def rack_app
            @rack_app ||= RackWrapper.new(self)
          end
        end
      end
    end
  end
end
