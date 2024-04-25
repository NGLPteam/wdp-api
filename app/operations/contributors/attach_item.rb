# frozen_string_literal: true

module Contributors
  class AttachItem
    include Dry::Monads[:result, :do]
    include MeruAPI::Deps[count: "contributors.count_items"]

    def call(contributor, item)
      contribution = contributor.item_contributions.where(item:).first_or_initialize

      contribution.save!

      yield count.call(contributor)

      Success contribution
    end
  end
end
