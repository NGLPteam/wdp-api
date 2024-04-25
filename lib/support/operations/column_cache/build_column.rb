# frozen_string_literal: true

module Support
  module ColumnCache
    class BuildColumn
      include Dry::Monads[:result]

      # @param [Class<ActiveRecord::Base>]
      # @param [ActiveRecord::ConnectionAdapters::PostgreSQL::Column] column
      # @return [Dry::Monads::Success(Support::ColumnCache::ColumnEntry)]
      def call(column, model_name:, **shared_attributes)
        name = column.name

        id = "#{model_name}##{name}"

        type = column.type

        null = column.null

        sql_type_metadata = column.sql_type_metadata.as_json.compact

        default = column.default

        default_function = column.default_function

        has_default = column.has_default?

        virtual = column.virtual?

        attributes = {
          **shared_attributes,
          model_name:,
          id:,
          name:,
          type:,
          null:,
          sql_type_metadata:,
          default:,
          default_function:,
          has_default:,
          virtual:,
        }

        entry = Support::ColumnCache::ColumnEntry.new(**attributes)

        Success entry
      end
    end
  end
end
