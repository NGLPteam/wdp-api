# frozen_string_literal: true

class Entity < ApplicationRecord
  belongs_to :hierarchical, polymorphic: true

  class << self
    # @return [void]
    def resync!
      Community.find_each(&:sync_entity!)
      Collection.find_each(&:sync_entity!)
      Item.find_each(&:sync_entity!)
    end
  end
end
