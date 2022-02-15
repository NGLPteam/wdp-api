# frozen_string_literal: true

module Loaders
  class RecordLoader < GraphQL::Batch::Loader
    def initialize(model, column: model.primary_key, order: nil, where: nil)
      super()
      @model = model
      @column = column.to_s
      @column_type = model.type_for_attribute(@column)
      @order = order if order.present?
      @is_primary_key = column == model.primary_key
      @where = where
    end

    def load(key)
      super(@column_type.cast(key))
    end

    def perform(keys)
      query(keys).each do |record|
        key = record.public_send(@column)

        next if fulfilled? key

        fulfill(key, record)
      end

      keys.each { |key| fulfill(key, nil) unless fulfilled?(key) }
    end

    private

    def query(keys)
      scope = @model.all
      scope = scope.where(@where) if @where

      unless @is_primary_key
        scope = scope.distinct_on @column
        scope = scope.order @column
        scope = scope.order @order
      end

      scope.where(@column => keys)
    end
  end
end
