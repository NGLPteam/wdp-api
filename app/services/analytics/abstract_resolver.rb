# frozen_string_literal: true

module Analytics
  # @abstract
  class AbstractResolver
    extend ActiveModel::Callbacks
    extend Dry::Core::ClassAttributes
    extend Dry::Initializer

    define_model_callbacks :prepare, :build, :funnel, only: %i[before after]

    defines :model, type: Models::Types::ModelClass

    model Ahoy::Event

    defines :time_column, type: Analytics::Types::Symbol

    time_column :time

    after_build :record_unfiltered_count!

    # @return [ActiveRecord::Relation]
    def call
      @current_scope = initialize_scope

      run_callbacks :prepare do
        prepare!
      end

      run_callbacks :build do
        build!
      end

      run_callbacks :funnel do
        funnel!
      end

      return @current_scope
    end

    # @return [Integer]
    attr_reader :unfiltered_count

    # @return [Class(ApplicationRecord)]
    def model
      self.class.model
    end

    # @!attribute [r] time_attribute
    # @return [Arel::Attribute]
    def time_attribute
      model.arel_table[time_column]
    end

    # @!attribute [r] time_column
    # @return [Symbol]
    def time_column
      self.class.time_column
    end

    # @!group Steps

    # @api private
    # @abstract
    # @return [void]
    def prepare!; end

    # @api private
    # @abstract
    # @return [void]
    def build!; end

    # @api private
    # @abstract
    # @return [void]
    def funnel!; end

    # @!endgroup

    # @!group Scope Manipulation

    # @abstract
    # @return [ActiveRecord::Relation]
    def initialize_scope
      base_scope.all
    end

    # @yieldparam [ActiveRecord::Relation] current_scope
    # @yieldreturn [ActiveRecord::Relation]
    # @return [void]
    def augment_scope!
      new_scope = yield @current_scope

      @current_scope = new_scope unless new_scope.nil?
    end

    # @!endgroup

    private

    # @return [ActiveRecord::Relation]
    def base_scope
      self.class.model.all
    end

    # @return [void]
    def record_unfiltered_count!
      @unfiltered_count = @current_scope.count
    end
  end
end
