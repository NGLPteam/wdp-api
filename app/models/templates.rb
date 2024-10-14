# frozen_string_literal: true

# A namespace for views and tables that are purely for auditing.
module Templates
  class << self
    def table_name_prefix
      "templates_"
    end
  end
end
