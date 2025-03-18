# frozen_string_literal: true

# A simple concern for setting a transient boolean
# on model records that may be modified by the admin.
module ModifiedByAdmin
  extend ActiveSupport::Concern

  # @return [Boolean]
  attr_accessor :modified_by_admin

  alias modified_by_admin? modified_by_admin
end
