# frozen_string_literal: true

module Templates
  class BuildAssigns < Support::SimpleServiceOperation
    service_klass Templates::AssignsBuilder
  end
end
