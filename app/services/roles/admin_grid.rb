# frozen_string_literal: true

module Roles
  class AdminGrid
    include Roles::Grid

    permission :access
  end
end
