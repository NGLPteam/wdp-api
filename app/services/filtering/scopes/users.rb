# frozen_string_literal: true

module Filtering
  module Scopes
    class Users < Filtering::FilterScope[User]
      simple_scope_filter! :email, :string do |arg|
        arg.description "Look for an exact email match."
      end
    end
  end
end
