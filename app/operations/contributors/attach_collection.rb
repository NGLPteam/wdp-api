# frozen_string_literal: true

module Contributors
  class AttachCollection
    include Dry::Monads[:result, :do]
    include WDPAPI::Deps[count: "contributors.count_collections"]

    def call(contributor, collection)
      contribution = contributor.collection_contributions.where(collection: collection).first_or_initialize

      contribution.save!

      yield count.call(contributor)

      Success contribution
    end
  end
end
