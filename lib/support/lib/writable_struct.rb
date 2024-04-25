# frozen_string_literal: true

module Support
  # @abstract
  class WritableStruct < Support::FlexibleStruct
    # @param [{ Symbol => Object }] new_values
    # @return [void]
    def update!(**new_values)
      new_attributes = @attributes.merge(new_values)

      @attributes = self.class.schema.call_unsafe(new_attributes)
    end

    private

    # @param [Symbol] key
    # @param [Object] value
    # @return [void]
    def set_value!(key, value)
      attrs = { key => value }

      update!(**attrs)
    end

    class << self
      private

      # @return [void]
      def define_accessors(keys)
        super

        keys.each do |key|
          writer = :"#{key}="

          next if writer.in?(instance_methods)

          class_eval <<~RUBY, __FILE__, __LINE__ + 1
          def #{writer}(raw_value)
            set_value!(#{key.to_sym.inspect}, raw_value)
          end
          RUBY
        end
      end
    end
  end
end
