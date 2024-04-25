# frozen_string_literal: true

module Support
  module HookBased
    # @abstract
    class AbstractHookModule < Module
      include Dry::Initializer[undefined: false].define -> do
        param :hook_name, Types::HookName
      end

      def inspect
        # :nocov:
        "#{self.class}[#{hook_name.inspect}]"
        # :nocov:
      end
    end
  end
end
