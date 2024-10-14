# frozen_string_literal: true

# A namespace for views and tables that are purely for auditing.
module Layouts
  class << self
    def table_name_prefix
      "layouts_"
    end
  end
end
