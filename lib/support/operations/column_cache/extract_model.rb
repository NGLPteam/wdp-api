# frozen_string_literal: true

module Support
  module ColumnCache
    class ExtractModel
      include Dry::Monads[:result, :list]

      include Support::Deps[
        build_column: "column_cache.build_column",
      ]

      # @param [Class<ActiveRecord::Base>]
      def call(model_klass)
        return Success([]) unless model_klass.table_exists?

        model_klass.reset_column_information

        shared_attributes = {
          model_name: model_klass.name,
          table_name: model_klass.table_name,
        }

        list = model_klass.columns.map do |column|
          build_column.(column, **shared_attributes)
        end

        List::Result.coerce(list).traverse.to_result.fmap(&:to_a)
      end
    end
  end
end
