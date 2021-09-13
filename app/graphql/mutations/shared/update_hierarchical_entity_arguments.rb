# frozen_string_literal: true

module Mutations
  module Shared
    module UpdateHierarchicalEntityArguments
      extend ActiveSupport::Concern

      include Mutations::Shared::HierarchicalEntityArguments
      include Mutations::Shared::UpdateEntityArguments
    end
  end
end
