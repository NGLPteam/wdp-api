# frozen_string_literal: true

module Templates
  module Digests
    module Utility
      # @see Templates::Digests::Utility::BuildInstanceQuery
      class InstanceQueryBuilder < Support::HookBased::Actor
        using Templates::Refinements::DigestQueryBuilder

        include Dry::Initializer[undefined: false].define -> do
          option :for_derived, Templates::Types::Bool, default: proc { false }

          option :view_version, Templates::Types::Integer, default: proc { 1 }

          option :write_view, Templates::Types::Bool, default: proc { false }
        end

        standard_execution!

        QUOTED_TABLE = %["templates_instance_digests"]

        UNIQUE_BY = %i[
          template_instance_id
          template_instance_type
        ].freeze

        COLUMNS = ::Templates::Digests::INSTANCE_COLUMNS

        PROJECTION = COLUMNS.map { ApplicationRecord.connection.quote_column_name(_1) }.join(", ").freeze

        SET_COLUMNS_EXPRS = (COLUMNS.without(*UNIQUE_BY).map do |column|
          quoted = ApplicationRecord.connection.quote_column_name(column)

          "#{quoted} = EXCLUDED.#{quoted}"
        end << %[updated_at = CURRENT_TIMESTAMP]).join(",\n").freeze

        DERIVED_QUERY_FORMAT = <<~SQL.freeze
        WITH digested_template_instances AS (
        %<unions>s
        )
        SELECT #{PROJECTION}, "created_at", "updated_at" FROM digested_template_instances
        SQL

        UPSERT_QUERY_FORMAT = <<~SQL.freeze
        WITH digested_template_instances AS (
        %<unions>s
        )
        INSERT INTO #{QUOTED_TABLE}(#{PROJECTION})
        SELECT #{PROJECTION} FROM digested_template_instances
        ON CONFLICT (template_instance_id, template_instance_type) DO UPDATE SET
        #{SET_COLUMNS_EXPRS.indent(2)}
        SQL

        # @return [<Arel::Nodes::SqlLiteral>]
        attr_reader :inner_queries

        # @return [String]
        attr_reader :query

        # @return [Arel::Nodes::UnionAll]
        attr_reader :unions

        # @return [Dry::Monads::Success(String)]
        def call
          run_callbacks :execute do
            yield prepare!

            yield build_query!

            yield write_view_query!
          end

          Success query
        end

        wrapped_hook! def prepare
          @inner_queries = build_inner_queries

          @unions = build_unions

          @query_format = for_derived ? DERIVED_QUERY_FORMAT : UPSERT_QUERY_FORMAT

          @query_options = { unions: }

          @view_name = "templates_derived_instance_digests_v%02d.sql" % view_version

          @view_path = Rails.root.join("db", "views", @view_name)

          super
        end

        wrapped_hook! def build_query
          @query = @query_format % @query_options

          super
        end

        wrapped_hook! def write_view_query
          return super unless for_derived && write_view

          @view_path.open("w+") { _1.write query }

          super
        end

        private

        def build_inner_queries
          Template.all.map { Arel.sql _1.instance_klass.digest_build_query(for_derived:).to_sql }
        end

        def build_unions
          inner_queries.reduce do |left, right|
            Arel::Nodes::UnionAll.new(left, right)
          end.to_sql.gsub(/\s+UNION ALL\s+/, "\nUNION ALL\n").indent(2)
        end
      end
    end
  end
end
