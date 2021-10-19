# frozen_string_literal: true

module Types
  class UserProfileInputType < Types::BaseInputObject
    description <<~TEXT
    A mapping of attributes for a user to update in the authentication provider.
    TEXT

    argument :given_name, String, required: true, attribute: true
    argument :family_name, String, required: true, attribute: true
    argument :email, String, required: true, attribute: true
    argument :username, String, required: true, attribute: true

    def prepare
      to_h.symbolize_keys
    end
  end
end
