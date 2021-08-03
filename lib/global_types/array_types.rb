# frozen_string_literal: true

module GlobalTypes
  class AnyArray < ActiveModel::Type::Value
    extend Dry::Core::ClassAttributes

    defines :element_type

    element_type Dry::Types["any"]

    def cast(value)
      Dry::Types['coercible.array'].of(self.class.element_type).try(value).to_monad.value_or([])
    end

    def type
      self.class.type
    end

    class << self
      def type
        @type ||= name.demodulize.parameterize.underscore.to_sym
      end
    end
  end

  class StringArray < AnyArray
    element_type Dry::Types["coercible.string"]
  end

  class IntegerArray < AnyArray
    element_type Dry::Types["coercible.integer"]
  end

  class AnyJSON < ActiveModel::Type::Value
    def cast(value)
      value.as_json
    end

    def type
      :any_json
    end
  end
end
