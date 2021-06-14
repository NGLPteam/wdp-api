# frozen_string_literal: true

# This represents something to which an {AccessGrant} can assign a {Role}
# for a given {Accessible} entity, namely a {User}.
module AccessGrantSubject
  extend ActiveSupport::Concern

  included do
    has_many :access_grants, as: :subject, dependent: :destroy
  end
end
