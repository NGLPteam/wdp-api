# frozen_string_literal: true

module Seeding
  module Brokers
    # A broker for handling {Collection}.
    class CollectionBroker < Broker
      include EntityBroker

      model_klass ::Collection
    end
  end
end
