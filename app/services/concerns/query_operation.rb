# frozen_string_literal: true

module QueryOperation
  extend ActiveSupport::Concern

  included do
    include Dry::Monads[:result]
  end

  def sql_insert!(*parts)
    # We use exec_query instead of exec_insert,
    # because we want control over RETURNING
    connection.exec_query compile_query(*parts)
  end

  def sql_delete!(*parts)
    connection.exec_delete compile_query(*parts)
  end

  def connection
    ApplicationRecord.connection
  end

  def compile_query(*parts, join_with: " ")
    parts.flatten.map(&:presence).compact.join(join_with).strip
  end

  def compile_and(*parts)
    compile_query(*parts, join_with: " AND ")
  end

  def with_quoted_id_for(model, template)
    return "" if model.blank? || model.new_record?

    with_sql_template template, model.quoted_id
  end

  def with_sql_template(template, *values)
    formatted = template % values

    cleanup_query formatted
  end

  private

  def cleanup_query(sql)
    sql.strip_heredoc.squish
  end
end
