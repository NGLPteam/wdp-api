# frozen_string_literal: true

module Entities
  # Given variable input, try to extract a DOI from it and return
  # a more useful {Entities::DOIReference}.
  class ExtractDOI
    include Dry::Monads[:do, :result]

    QUACKS_DOI = Entities::Types.Interface(:doi)

    # @param [ChildEntity, String, #doi] input
    # @return [Dry::Monads::Success(Entities::DOIReference)]
    # @return [Dry::Monads::Failure(:invalid_doi, Object)]
    def call(input)
      return Success(input) if input.kind_of?(Entities::DOIReference)

      doi = yield extract input

      reference = Entities::DOIReference.new(doi:)

      Success reference
    end

    private

    # @param [ChildEntity, String, #doi] input
    # @return [Dry::Monads::Success(Entities::Types::DOI)]
    # @return [Dry::Monads::Failure(:invalid_doi, Object)]
    def extract(input)
      case input
      when Entities::Types::DOI
        Success(input)
      when Entities::Types::DOI_URL_PATTERN
        extract(Regexp.last_match[:doi])
      when ChildEntity, QUACKS_DOI
        extract(input.doi)
      else
        Failure[:invalid_doi, input]
      end
    end
  end
end
