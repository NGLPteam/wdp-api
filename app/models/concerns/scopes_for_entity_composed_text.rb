# frozen_string_literal: true

# @see EntityComposedText
module ScopesForEntityComposedText
  extend ActiveSupport::Concern

  class_methods do
    def by_composed_text(query, dictionary: "english")
      return all if query.blank?

      left_outer_joins(:entity_composed_text).merge(EntityComposedText.websearch(query, dictionary: dictionary))
    end
  end
end
