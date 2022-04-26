# frozen_string_literal: true

module Seeding
  module Brokers
    # A broker for handling {Community}.
    class CommunityBroker < Broker
      include EntityBroker

      model_klass ::Community
    end
  end
end
