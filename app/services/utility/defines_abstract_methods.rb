# frozen_string_literal: true

module Utility
  module DefinesAbstractMethods
    extend ActiveSupport::Concern

    module ClassMethods
      def abstract_method!(name, signature: "...")
        class_eval <<~RUBY, __FILE__, __LINE__ + 1
        def #{name}(#{signature})
          raise NotImplementedError, "Must implement \#{self.class.name}#\#{__method__}(#{signature})"
        end
        RUBY
      end
    end
  end
end
