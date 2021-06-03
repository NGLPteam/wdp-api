# frozen_string_literal: true

class DerivedPermission < ApplicationRecord
  include ScopesForHierarchical
  include ScopesForUser
  include View

  belongs_to :hierarchical, polymorphic: true, optional: false
  belongs_to :user, optional: false
end
