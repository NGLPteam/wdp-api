# frozen_string_literal: true

module Mutations
  module Shared
    module CreateHierarchicalEntityArguments
      extend ActiveSupport::Concern

      include Mutations::Shared::HierarchicalEntityArguments
      include Mutations::Shared::CreateEntityArguments
    end
  end
end
