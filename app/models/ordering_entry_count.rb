# frozen_string_literal: true

# A summary of how many visible {OrderingEntry entries} are contained in an {Ordering}
# at the time the view is refreshed. This view is refreshed on a schedule and is used
# to make calculating the {InitialOrderingDerivation} more efficient system-wide.
class OrderingEntryCount < ApplicationRecord
  include MaterializedView

  self.primary_key = :ordering_id

  belongs_to :ordering, inverse_of: :ordering_entry_count
end
