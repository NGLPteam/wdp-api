# frozen_string_literal: true

# This represents something to which an {AccessGrant} can assign a {Role}
# for a given {Accessible} entity, namely a {User}.
module AccessGrantSubject
  extend ActiveSupport::Concern

  included do
    has_many :access_grants, as: :subject, dependent: :destroy

    scope :with_granted_asset_creation, -> { where(id: unscoped.joins(:access_grants).merge(AccessGrant.with_asset_creation)) }
  end

  def has_granted_asset_creation?
    access_grants.with_asset_creation?
  end
end
