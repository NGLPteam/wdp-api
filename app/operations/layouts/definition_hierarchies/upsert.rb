# frozen_string_literal: true

module Layouts
  module DefinitionHierarchies
    # @see Layouts::DefinitionHierarchies::Upserter
    class Upsert < Support::SimpleServiceOperation
      service_klass Layouts::DefinitionHierarchies::Upserter
    end
  end
end
