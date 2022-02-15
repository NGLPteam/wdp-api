# frozen_string_literal: true

module HasUniqueORCID
  extend ActiveSupport::Concern

  included do
    scope :by_orcid, ->(orcid) { where(orcid: orcid) }
    validates :orcid, uniqueness: { if: :orcid? }

    before_validation :nullify_blank_orcid!
  end

  # @api private
  # @return [void]
  def nullify_blank_orcid!
    self.orcid = nil if orcid.blank?
  end

  module ClassMethods
    def has_existing_orcid?(orcid, except: nil)
      return false if orcid.blank?

      relation = by_orcid(orcid)

      relation = relation.where.not(id: except.id) if except.present? && except.persisted?

      relation.exists?
    end
  end
end
