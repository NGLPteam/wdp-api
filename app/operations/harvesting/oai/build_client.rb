# frozen_string_literal: true

module Harvesting
  module OAI
    class BuildClient
      include Dry::Monads[:result]

      # @param [HarvestSource] harvest_source
      # @return [OAI::Client]
      def call(harvest_source)
        client = ::OAI::Client.new harvest_source.base_url

        Success client
      end
    end
  end
end
