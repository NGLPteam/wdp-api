# frozen_string_literal: true

module Support
  module Migrations
    class ColumnRef < QuotableRef
      def quote(value)
        quote_column_name value
      end
    end
  end
end
