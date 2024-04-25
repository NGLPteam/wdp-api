# frozen_string_literal: true

module Support
  module Migrations
    module QuotationHelpers
      delegate :connection, to: ApplicationRecord

      delegate :quote_table_name, :quote_column_name, to: :connection
    end
  end
end
