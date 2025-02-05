# frozen_string_literal: true

module HasDOI
  extend ActiveSupport::Concern
  extend DefinesMonadicOperation

  DOI_PATTERN = Entities::Types::DOI_PATTERN
  DOI_SQL_PATTERN = Entities::Types::DOI_SQL_PATTERN

  included do
    scope :with_valid_doi, -> { where(arel_has_valid_doi) }
    scope :sans_valid_doi, -> { where(arel_has_invalid_doi) }
  end

  delegate :link, :url, to: :doi_reference, prefix: :doi, allow_nil: true

  # @return [Entities::DOIReference, nil]
  def doi_reference
    extract_doi.value_or(nil)
  end

  # @see Entities::ExtractDOI
  # @return [Dry::Monads::Success(Entities::DOIReference)]
  monadic_operation! def extract_doi
    call_operation("entities.extract_doi", self)
  end

  def has_doi?
    doi? && doi.match?(DOI_PATTERN)
  end

  alias has_doi has_doi?

  module ClassMethods
    def arel_has_valid_doi
      arel_has_valid_doi_on(arel_table[:doi])
    end

    def arel_has_invalid_doi
      arel_has_invalid_doi_on(arel_table[:doi])
    end

    def arel_has_valid_doi_on(expr)
      arel_attrify(expr).matches_regexp(DOI_SQL_PATTERN, false)
    end

    def arel_has_invalid_doi_on(expr)
      attr = arel_attrify(expr)

      no_match = attr.does_not_match_regexp(DOI_SQL_PATTERN, false)
      is_null = attr.eq(nil)

      is_null.or(no_match)
    end
  end
end
