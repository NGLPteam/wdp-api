# frozen_string_literal: true

class ItemContribution < ApplicationRecord
  include Contribution

  belongs_to :contributor, inverse_of: :item_contributions
  belongs_to :item, inverse_of: :contributions
end
