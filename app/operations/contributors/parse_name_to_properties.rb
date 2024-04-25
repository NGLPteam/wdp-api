# frozen_string_literal: true

module Contributors
  # @see Contributors::NameParser
  class ParseNameToProperties
    include Dry::Monads[:do, :result]
    include MeruAPI::Deps[
      parse_name: "utility.parse_name",
    ]

    # @param [String] name
    # @param [:person, :organization] kind
    # @return [Dry::Monads::Success(Hash)]
    def call(name, kind: nil)
      options = {}

      options[:kind] = kind if kind

      Contributors::NameParser.new(name, **options).call
    end
  end
end
