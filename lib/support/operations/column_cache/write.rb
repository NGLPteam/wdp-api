# frozen_string_literal: true

module Support
  module ColumnCache
    class Write
      include Dry::Monads[:result, :do]

      include Support::Deps[
        extract_models: "column_cache.extract_models",
      ]

      FROZEN_ROOT = Support::System.root.join("../frozen_record")

      COLUMNS = FROZEN_ROOT.join("static_cached_columns.yml")

      # @param [Class<ActiveRecord::Base>]
      def call
        columns = yield extract_models.()

        COLUMNS.open("w+") do |f|
          f.write YAML.dump columns.map(&:as_json)
        end

        Success()
      end
    end
  end
end
