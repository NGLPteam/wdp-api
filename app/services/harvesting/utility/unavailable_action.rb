# frozen_string_literal: true

module Harvesting
  module Utility
    class UnavailableAction
      include Dry::Monads[:result]
      include Dry::Initializer[undefined: false].define -> do
        param :type, Dry::Types["symbol"].enum(:protocol, :metadata_format)
        param :name, Dry::Types["string"]
        param :action_name, Dry::Types["symbol"]
      end

      def call(...)
        Failure[:unavailable_action, "The #{type} #{name.inspect} does not implement #{action_name.inspect}"]
      end
    end
  end
end
