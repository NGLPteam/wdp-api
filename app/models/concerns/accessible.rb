# frozen_string_literal: true

# This represents an entity which an {AccessGrantSubject} can
# {AccessGrant have access granted} with a {Role}.
module Accessible
  extend ActiveSupport::Concern

  included do
    has_many :access_grants, as: :accessible, dependent: :destroy
  end
end
