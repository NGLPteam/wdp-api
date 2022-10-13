# frozen_string_literal: true

module PilotHarvesting
  class Seed
    def call(key)
      root = PilotCommunity.root_for key

      root.call
    end
  end
end
