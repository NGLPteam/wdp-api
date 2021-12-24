# frozen_string_literal: true

module NamedVariableDates
  module Global
    # Instance methods for {WritesNamedVariableDates::ClassMethods#writes_named_variable_date!}
    class WriterInstanceMethods < NamedVariableDates::MethodBuilder
      def compile_methods!
        class_eval <<~RUBY, __FILE__, __LINE__ + 1
        def #{@name}=(new_value)
          write_named_variable_date! #{@name.inspect}, new_value
        end
        RUBY
      end
    end
  end
end
