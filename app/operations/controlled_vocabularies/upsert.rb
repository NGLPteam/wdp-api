# frozen_string_literal: true

module ControlledVocabularies
  # Parse and persist a {ControlledVocabulary} root definition.
  class Upsert
    include Dry::Monads[:result, :do]

    include MeruAPI::Deps[
      parse: "controlled_vocabularies.parse",
      persist: "controlled_vocabularies.persistence.persist",
    ]

    def call(input)
      root = yield parse.(input)

      controlled_vocabulary = yield persist.(root)

      Success controlled_vocabulary
    end
  end
end
