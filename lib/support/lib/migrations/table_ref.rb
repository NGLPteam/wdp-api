# frozen_string_literal: true

module Support
  module Migrations
    class TableRef < QuotableRef
      def quote(value)
        quote_table_name value
      end
    end
  end
end
