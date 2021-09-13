# frozen_string_literal: true

# The identifier field on an {Item} or {Collection} is not currently used or exposed through the API.
# It will likely get reassessed once we have integrations with external imports. For now, we generate
# a random UUID and use that to keep the value present and unique.
module AutoIdentifier
  extend ActiveSupport::Concern

  included do
    before_validation :maybe_set_identifier!
  end

  # @api private
  # @return [void]
  def maybe_set_identifier!
    self.identifier = SecureRandom.uuid if identifier.blank?
  end
end
