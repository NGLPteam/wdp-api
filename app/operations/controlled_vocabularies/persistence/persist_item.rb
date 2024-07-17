# frozen_string_literal: true

module ControlledVocabularies
  module Persistence
    class PersistItem < Support::SimpleServiceOperation
      service_klass ControlledVocabularies::Persistence::ItemPersistor
    end
  end
end
