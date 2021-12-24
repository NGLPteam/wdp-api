# frozen_string_literal: true

module NamedVariableDates
  module Global
    # Class methods for {ReferencesNamedVariableDates::ClassMethods#reads_named_variable_date!}
    class ReaderClassMethods < NamedVariableDates::MethodBuilder
      def compile_methods!
        class_eval <<~RUBY, __FILE__, __LINE__ + 1
        def with_sorted_#{@name}_date(dir)
          with_sorted_global_variable_date(#{@name.inspect}, dir)
        end

        def with_oldest_#{@name}_date
          with_oldest_global_variable_date #{@name.inspect}
        end

        def with_recent_#{@name}_date
          with_recent_global_variable_date #{@name.inspect}
        end
        RUBY
      end
    end
  end
end
