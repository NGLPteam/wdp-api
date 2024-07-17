# frozen_string_literal: true

module HasControlledVocabularyProvisions
  extend ActiveSupport::Concern

  module ClassMethods
    # @return [<String>]
    def distinct_provisions
      distinct.pluck(:provides)
    end
  end
end
