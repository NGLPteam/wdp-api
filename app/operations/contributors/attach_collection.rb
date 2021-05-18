# frozen_string_literal: true

module Contributors
  class AttachCollection
    include Dry::Monads[:result, :do]

    def call(contributor, collection)
      contribution = contributor.collection_contributions.where(collection: collection).first_or_initialize

      contribution.save!

      Success contribution
    end
  end
end
