# frozen_string_literal: true

class CollectionContribution < ApplicationRecord
  include Contribution

  belongs_to :contributor, inverse_of: :collection_contributions
  belongs_to :collection, inverse_of: :contributions
end
