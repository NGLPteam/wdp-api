# frozen_string_literal: true

module PilotHarvesting
  # @see PilotHarvesting::SourceUpserter
  class UpsertSource < Support::SimpleServiceOperation
    service_klass PilotHarvesting::SourceUpserter
  end
end
