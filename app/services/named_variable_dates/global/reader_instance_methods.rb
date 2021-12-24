# frozen_string_literal: true

module NamedVariableDates
  module Global
    # Instance methods for {ReferencesNamedVariableDates::ClassMethods#reads_named_variable_date!}
    class ReaderInstanceMethods < NamedVariableDates::MethodBuilder
      def compile_methods!
        class_eval <<~RUBY, __FILE__, __LINE__ + 1
        def #{@name}
          named_variable_date_value_for(#{@name.inspect})
        end
        RUBY
      end
    end
  end
end
