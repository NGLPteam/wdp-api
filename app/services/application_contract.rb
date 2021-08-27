# frozen_string_literal: true

class ApplicationContract < Dry::Validation::Contract
  import_predicates_as_macros

  register_macro :entity do
    key.failure(:must_be_entity) unless value.kind_of?(::HierarchicalEntity)
  end

  register_macro :email_format do
    key.failure(:must_be_email) unless AppTypes::EMAIL_PATTERN.match? value
  end

  register_macro :maybe_email_format do
    key.failure(:must_be_email) unless value.blank? || AppTypes::EMAIL_PATTERN.match?(value)
  end

  register_macro :maybe_url_format do
    key.failure(:must_be_url) unless value.blank? || URI::DEFAULT_PARSER.make_regexp(%w[http https]).match?(value)
  end

  register_macro :tag_format do
    key.failure("cannot contain a comma") if key? && value.include?(?,)
  end

  register_macro :url_format do
    key.failure(:must_be_url) unless URI::DEFAULT_PARSER.make_regexp(%w[http https]).match?(value)
  end
end
