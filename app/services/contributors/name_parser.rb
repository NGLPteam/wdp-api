# frozen_string_literal: true

module Contributors
  # @see Contributors::ParseNameToProperties
  class NameParser
    include Dry::Monads[:do, :result]
    include Dry::Initializer[undefined: false].define -> do
      param :name, Contributors::Types::String

      option :kind, Contributors::Types::Kind, default: proc { Contributors::Types::PersonalName.valid?(name) ? :person : :organization }
    end
    include MeruAPI::Deps[
      parse_name: "utility.parse_name",
    ]

    # @return [Dry::Monads::Success(Hash)]
    def call
      case kind
      when :person
        to_person_properties
      else
        to_organization_properties
      end
    end

    private

    # @return [Dry::Monads::Success(Hash)]
    def to_person_properties
      parsed = yield parse_name.(name)

      props = {}.tap do |h|
        h[:given_name] = parsed.given
        h[:family_name] = parsed.family
        h[:appellation] = parsed.title.presence || parsed.appellation
        h[:parsed] = parsed.as_json
      end

      Success props
    end

    # @return [Dry::Monads::Success(Hash)]
    def to_organization_properties
      props = {}.tap do |p|
        p[:legal_name] = name
      end

      Success props
    end
  end
end
