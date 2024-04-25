# frozen_string_literal: true

# Because of harvesting, we don't actually enforce a unique DOI at the database level, only
# for creating and updating through the API. Duplicate records _shouldn't_ enter the system
# through harvesting, but it's possible.
module HasUniqueDOI
  extend ActiveSupport::Concern

  included do
    scope :by_doi, ->(doi) { where(doi:) }

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
