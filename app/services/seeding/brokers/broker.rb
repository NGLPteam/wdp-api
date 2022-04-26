# frozen_string_literal: true

module Seeding
  module Brokers
    # @abstract
    class Broker < Dry::Struct
      extend Dry::Core::ClassAttributes
    end
  end
end
