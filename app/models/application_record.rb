# frozen_string_literal: true

class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  include DerivedGraphqlTypes

  # @return [String]
  def to_encoded_id
    WDPAPI::Container["relay_node.id_from_object"].call(self).value! if persisted?
  end

  class << self
    def arel_text_contains(field, value)
      arel_table[field].matches("%#{escape_ilike_needle(value)}%")
    end

    def escape_ilike_needle(needle)
      needle.gsub("%", "\\%").gsub("_", "\\_")
    end
  end
end
