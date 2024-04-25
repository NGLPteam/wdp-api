# frozen_string_literal: true

module Contributors
  class RecountContributions
    include Dry::Monads[:result, :do]
    include MeruAPI::Deps[
      count_collections: "contributors.count_collections",
      count_items: "contributors.count_items",
    ]

    def call(contributor)
      yield count_collections.call(contributor)
      yield count_items.call(contributor)

      Success nil
    end
  end
end
