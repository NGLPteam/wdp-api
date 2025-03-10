# frozen_string_literal: true

module EsploroSchema
  module Common
    class WrappedAttributeAccessor < Module
      include Dry::Core::Equalizer.new(:unwrapped_name)

      include Dry::Initializer[undefined: false].define -> do
        param :unwrapped_name, EsploroSchema::Types::UnwrappedAttributeName
        param :wrapped_name, EsploroSchema::Types::WrappedAttributeName

        option :type, EsploroSchema::Common::AbstractWrapper::Subclass
      end

      def initialize(...)
        super

        class_eval <<~RUBY, __FILE__, __LINE__ + 1
        def #{unwrapped_name}
          unwrap_attribute_values_for(#{wrapped_name.inspect})
        end
        RUBY
      end
    end
  end
end
