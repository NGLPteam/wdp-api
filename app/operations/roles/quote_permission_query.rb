# frozen_string_literal: true

module Roles
  class QuotePermissionQuery
    def call(value)
      case value
      when Roles::Types::PermissionQuery
        parts = value.scan(Roles::Types::PERMISSION_QUERY_PART).map do |part|
          part == ?* ? Roles::Types::PERMISSION_PART : part
        end

        /\A#{parts.join("\\.")}\z/
      end
    end
  end
end
