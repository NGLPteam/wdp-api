# frozen_string_literal: true

module ControlledVocabularies
  module Persistence
    class Persist < Support::SimpleServiceOperation
      service_klass ControlledVocabularies::Persistence::Persistor
    end
  end
end
