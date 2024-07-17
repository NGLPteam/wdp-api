# frozen_string_literal: true

module ControlledVocabularies
  module Persistence
    class PersistRoot < Support::SimpleServiceOperation
      service_klass ControlledVocabularies::Persistence::RootPersistor
    end
  end
end
