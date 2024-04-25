# frozen_string_literal: true

module Filtering
  module HasArguments
    extend ActiveSupport::Concern

    included do
      extend Dry::Core::ClassAttributes
    end

    module ClassMethods
      def argument!(key, type, default_value: nil, replace_null: nil, **options)
        dry_type = arguments.add! key, type, **options do |arg|
          yield arg if block_given?

          arg.default default_value, replace_null:
        end

        option key, dry_type, optional: true
      end

      def boolean_scope!(key, truthy_scope: key, falsey_scope: nil, **options)
        argument! key, :bool, **options do |arg|
          yield arg if block_given?
        end

        on_true = "scope.#{truthy_scope}"

        on_false = falsey_scope.present? ? "scope.#{falsey_scope}" : "scope.all"

        class_eval <<~RUBY, __FILE__, __LINE__ + 1
        after_build def apply_#{key}!
          augment_scope! do |scope|
            case #{key}
            when true
              #{on_true}
            when false
              #{on_false}
            end
          end
        end
        RUBY
      end

      def date_match!(key, column_name: key)
        argument! key, :date_match do |arg|
          arg.description <<~TEXT
          Filter the model's `#{column_name}` with date constraints.
          TEXT
        end

        class_eval <<~RUBY, __FILE__, __LINE__ + 1
        after_build def apply_#{key}!
          attribute = self.class.model_klass.arel_table[#{column_name.to_sym.inspect}]

          augment_scope! do |scope|
            scope.where(#{key}.(attribute)) if #{key}.present?
          end
        end
        RUBY
      end

      def float_match!(key, column_name: key)
        argument! key, :float_match do |arg|
          arg.description <<~TEXT
          Filter the model's `#{column_name}` with various float / decimal constraints.
          TEXT
        end

        class_eval <<~RUBY, __FILE__, __LINE__ + 1
        after_build def apply_#{key}!
          attribute = self.class.model_klass.arel_table[#{column_name.to_sym.inspect}]

          augment_scope! do |scope|
            scope.where(#{key}.(attribute)) if #{key}.present?
          end
        end
        RUBY
      end

      def fts_search!(search_scope, key: :q)
        argument! key, :string do |arg|
          arg.description <<~TEXT
          Perform a full-text search to approximately match the provided string.
          TEXT
        end

        class_eval <<~RUBY, __FILE__, __LINE__ + 1
        before_ranking def rank_#{search_scope}!
          augment_ranking! do |scope|
            scope.#{search_scope}(#{key}).with_pg_search_rank if #{key}.present?
          end
        end

        after_build def apply_#{search_scope}!
          augment_scope! do |scope|
            scope.#{search_scope}(#{key}) if #{key}.present?
          end
        end
        RUBY
      end

      def identifier_filter!
        simple_filter! :identifier, :string do |arg|
          arg.description "Look up by the record's unique identifier (exact match)."
        end
      end

      def integer_match!(key, column_name: key)
        argument! key, :integer_match do |arg|
          arg.description <<~TEXT
          Filter the model's `#{column_name}` with various integer constraints.
          TEXT
        end

        class_eval <<~RUBY, __FILE__, __LINE__ + 1
        after_build def apply_#{key}!
          attribute = self.class.model_klass.arel_table[#{column_name.to_sym.inspect}]

          augment_scope! do |scope|
            scope.where(#{key}.(attribute)) if #{key}.present?
          end
        end
        RUBY
      end

      def nested_filter!(association_name, type_name: :"#{association_name}_filters", key: :"#{association_name}_filters", **options)
        key = key.to_sym

        argument! key, type_name, **options do |arg|
          yield arg if block_given?
        end

        class_eval <<~RUBY, __FILE__, __LINE__ + 1
        after_build def apply_nested_#{association_name}_filters!
          augment_scope! do |scope|
            scope.filter_by_nested #{association_name.to_sym.inspect}, #{key}
          end
        end
        RUBY
      end

      def simple_filter!(key, type_name, column_name: key, **options)
        argument! key, type_name, **options do |arg|
          yield arg if block_given?
        end

        column_name = column_name.to_sym

        class_eval <<~RUBY, __FILE__, __LINE__ + 1
        after_build def apply_#{key}!
          augment_scope! do |scope|
            scope.where(#{column_name.inspect} => #{key}) unless #{key}.nil? || (#{key}.respond_to?(:empty?) && #{key}.empty?)
          end
        end
        RUBY
      end

      def simple_scope_filter!(key, type_name, scope_name: :"lookup_by_#{key}", **options)
        argument! key, type_name, **options do |arg|
          yield arg if block_given?
        end

        class_eval <<~RUBY, __FILE__, __LINE__ + 1
        after_build def apply_#{key}!
          augment_scope! do |scope|
            scope.#{scope_name}(#{key}) unless #{key}.blank?
          end
        end
        RUBY
      end

      def simple_state_filter!(enum_type, key: :in_state, in_state_scope: :in_state, **options)
        argument! key, enum_type, **options do |arg|
          yield arg if block_given?
        end

        class_eval <<~RUBY, __FILE__, __LINE__ + 1
        after_build def apply_#{key}!
          augment_scope! do |scope|
            scope.#{in_state_scope}(#{key}) if #{key}.present?
          end
        end
        RUBY
      end

      def simple_truthy_filter!(key, column_name: key, filter_false: false, **options)
        argument! key, :bool, **options do |arg|
          yield arg if block_given?
        end

        column_name = column_name.to_sym

        class_eval <<~RUBY, __FILE__, __LINE__ + 1
        after_build def apply_truthy_#{key}!
          augment_scope! do |scope|
            if #{key}
              scope.where(#{column_name.inspect} => true)
            elsif #{key} == false && #{filter_false}
              scope.where(#{column_name.inspect} => false)
            end
          end
        end
        RUBY
      end

      def time_match!(key, column_name: key)
        argument! key, :time_match do |arg|
          arg.description <<~TEXT
          Filter the model's `#{column_name}` with time constraints.
          TEXT
        end

        class_eval <<~RUBY, __FILE__, __LINE__ + 1
        after_build def apply_#{key}!
          attribute = self.class.model_klass.arel_table[#{column_name.to_sym.inspect}]

          augment_scope! do |scope|
            scope.where(#{key}.(attribute)) if #{key}.present?
          end
        end
        RUBY
      end

      def timestamps!
        time_match! :created_at
        time_match! :updated_at
      end

      # @return [void]
      def tracks_mutations!
        simple_scope_filter! :user, :users, scope_name: :touched_by_user do |arg|
          arg.description "Filter by records that were created OR updated by these users."
        end
      end

      # @api private
      def arguments
        @arguments ||= Filtering::Arguments.new
      end

      # @api private
      def inherited(subclass)
        super

        child_args = Filtering::Arguments.new.merge arguments

        subclass.instance_variable_set(:@arguments, child_args)
      end
    end
  end
end
