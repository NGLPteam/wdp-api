# frozen_string_literal: true

module Support
  module QueryResolver
    # @abstract
    class Base
      extend ActiveModel::Callbacks
      extend Dry::Core::ClassAttributes

      include Support::Requests::SetsConnectionInfo

      define_model_callbacks :prepare, :filter, :build, :finalize, only: %i[before after]

      before_filter :calculate_unfiltered_count!, if: :wants_unfiltered_count?

      before_finalize :calculate_total_count!, if: :wants_total_count?

      # @return [ActiveRecord::Relation]
      def call
        run_callbacks :prepare do
          prepare!
        end

        run_callbacks :filter do
          run_callbacks :build do
            build!
          end
        end

        run_callbacks :finalize do
          finalize!
        end

        return @current_scope
      end

      # @!group Steps

      # @api private
      # @abstract
      # @return [void]
      def prepare!
        @base_scope = initialize_scope
        @current_scope = @base_scope
      end

      # @api private
      # @abstract
      # @return [void]
      def build!; end

      # @api private
      # @abstract
      # @return [void]
      def finalize!; end

      # @abstract
      # @return [ActiveRecord::Relation]
      def initialize_scope
        ApplicationRecord.none
      end

      # @return [void]
      def calculate_total_count!
        increment_total_count! @current_scope.count
      end

      # @return [void]
      def calculate_unfiltered_count!
        increment_unfiltered_count! @current_scope.count
      end

      def exists_in_scope?(...)
        @base_scope.exists?(...)
      end

      def unique_in_scope?(...)
        @base_scope.unique_where?(...)
      end

      # @yieldparam [ActiveRecord::Relation] current_scope
      # @yieldreturn [ActiveRecord::Relation]
      # @return [void]
      def augment_scope!
        new_scope = yield @current_scope

        @current_scope = new_scope unless new_scope.nil?
      end
    end
  end
end
