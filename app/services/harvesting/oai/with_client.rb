# frozen_string_literal: true

module Harvesting
  module OAI
    module WithClient
      extend ActiveSupport::Concern

      included do
        include Dry::Effects.Resolve(:oai_client)
      end
    end
  end
end
