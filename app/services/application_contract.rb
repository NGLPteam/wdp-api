# frozen_string_literal: true

# @abstract
class ApplicationContract < Dry::Validation::Contract
  import_predicates_as_macros

  register_macro :entity do
    key.failure(:must_be_entity) unless value.kind_of?(::HierarchicalEntity)
  end

  register_macro :slug_format do
    key.failure(:must_be_slug) unless AppTypes::SLUG_PATTERN.match? value
  end

  register_macro :email_format do
    key.failure(:must_be_email) unless AppTypes::EMAIL_PATTERN.match? value
  end

  register_macro :maybe_email_format do
    key.failure(:must_be_email) unless value.blank? || AppTypes::EMAIL_PATTERN.match?(value)
  end

  register_macro :maybe_url_format do
    key.failure(:must_be_url) unless value.blank? || AppTypes::URL_PATTERN.match?(value)
  end

  register_macro :tag_format do
    key.failure("cannot contain a comma") if key? && value.include?(?,)
  end

  register_macro :url_format do
    key.failure(:must_be_url) unless AppTypes::URL_PATTERN.match?(value)
  end
end
