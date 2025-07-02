# frozen_string_literal: true

module Layouts
  module DefinitionHierarchies
    # @see Layouts::DefinitionHierarchies::Populator
    class Populate < Support::SimpleServiceOperation
      service_klass Layouts::DefinitionHierarchies::Populator
    end
  end
end
