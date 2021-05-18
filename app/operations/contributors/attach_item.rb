# frozen_string_literal: true

module Contributors
  class AttachItem
    include Dry::Monads[:result, :do]

    def call(contributor, item)
      contribution = contributor.item_contributions.where(item: item).first_or_initialize

      contribution.save!

      Success contribution
    end
  end
end
