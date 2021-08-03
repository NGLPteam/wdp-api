# frozen_string_literal: true

class ApplicationContract < Dry::Validation::Contract
  import_predicates_as_macros

  register_macro :email_format do
    key.failure("must be an email") unless AppTypes::EMAIL_PATTERN.match? value
  end

  register_macro :tag_format do
    key.failure("cannot contain a comma") if key? && value.include?(?,)
  end
end
