# frozen_string_literal: true

module HasEphemeralSystemSlug
  extend ActiveSupport::Concern

  # @return [String, nil]
  def system_slug
    WDPAPI::Container["slugs.encode_id"].call(system_slug_id).value_or(nil)
  end

  # @api private
  # @return [String]
  def system_slug_id
    id
  end
end
