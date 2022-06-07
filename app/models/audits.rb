# frozen_string_literal: true

# A namespace for views and tables that are purely for auditing.
module Audits
  class << self
    def table_name_prefix
      "audits_"
    end
  end
end
