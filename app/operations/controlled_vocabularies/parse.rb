# frozen_string_literal: true

module ControlledVocabularies
  class Parse
    include Dry::Monads[:result, :do]

    include MeruAPI::Deps[
      validate: "controlled_vocabularies.validate",
    ]

    # @param [Hash] input
    # @return [Dry::Monads::Success(ControlledVocabularies::Transient::Root)]
    def call(input)
      validated = yield validate.(input)

      parsed = ControlledVocabularies::Transient::Root.new(validated)

      Success parsed
    end
  end
end
