# frozen_string_literal: true

# Methods for working directly with SQL queries in operations.
module QueryOperation
  extend ActiveSupport::Concern

  included do
    include Dry::Monads[:result]

    delegate :quote_column_name, to: :connection
  end

  # @param [<String>] parts
  # @return [void]
  def sql_select!(*parts)
    connection.exec_query compile_query(*parts)
  end

  # @param [<String>] parts
  # @return [void]
  def sql_insert!(*parts)
    # We use exec_query instead of exec_insert,
    # because we want control over RETURNING
    connection.exec_query compile_query(*parts)
  end

  # @param [<String>] parts
  # @return [Integer]
  def sql_update!(*parts)
    connection.exec_update compile_query(*parts)
  end

  # @param [<String>] parts
  # @return [Integer]
  def sql_delete!(*parts)
    connection.exec_delete compile_query(*parts)
  end

  # @api private
  # @return [ActiveRecord::ConnectionAdapters::PostgreSQLAdapter]
  def connection
    ApplicationRecord.connection
  end

  # Join components of a query with the separator value in `join_with`.
  #
  # @param [<String>] parts
  # @param [String] join_with
  # @return [String]
  def compile_query(*parts, join_with: " ")
    parts.flatten.map(&:presence).compact.join(join_with).strip
  end

  # Join components of a query with ` AND `.
  #
  # @param [<String>] parts
  # @return [String]
  def compile_and(*parts)
    compile_query(*parts, join_with: " AND ")
  end

  # Provide the quoted model id as a formatting argument
  # to the `template`.
  #
  # @param [ApplicationRecord] model
  # @param [String] template
  # @return [String]
  def with_quoted_id_for(model, template)
    return "" if model.blank? || model.new_record?

    with_sql_template template, model.quoted_id
  end

  # @param [String] template
  # @param [<Object>] values format values for `String#%`
  # @return [String]
  def with_sql_template(template, *values)
    formatted = template % values

    cleanup_query formatted
  end

  private

  # @param [String] sql
  # @return [String]
  def cleanup_query(sql)
    sql.strip_heredoc.squish
  end
end
