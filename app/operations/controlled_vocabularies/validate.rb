# frozen_string_literal: true

module ControlledVocabularies
  class Validate < Support::SimpleServiceOperation
    service_klass ControlledVocabularies::Validator
  end
end
