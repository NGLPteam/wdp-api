# frozen_string_literal: true

RSpec::Matchers.define :be_an_encoded_slug do
  match do |actual|
    Support::System["slugs.decode_id"].(actual).bind do |decoded|
      Support::GlobalTypes::UUID.try(decoded).to_monad
    end.success?
  end
end
