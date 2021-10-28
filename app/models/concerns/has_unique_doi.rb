# frozen_string_literal: true

module HasUniqueDOI
  extend ActiveSupport::Concern

  included do
    scope :by_doi, ->(doi) { where(doi: doi) }
    validates :doi, uniqueness: { if: :doi? }

    before_validation :nullify_blank_doi!
  end

  # @api private
  # @return [void]
  def nullify_blank_doi!
    self.doi = nil if doi.blank?
  end

  module ClassMethods
    def has_existing_doi?(doi, except: nil)
      return false if doi.blank?

      relation = by_doi(doi)

      relation = relation.where.not(id: except.id) if except.present? && except.persisted?

      relation.exists?
    end
  end
end
