# frozen_string_literal: true

module Mutations
  module Shared
    module UpdateHierarchicalEntityArguments
      extend ActiveSupport::Concern

      include Mutations::Shared::HierarchicalEntityArguments
      include Mutations::Shared::UpdateEntityArguments

      included do
        argument :maintain_pristine_status, GraphQL::Types::Boolean, required: false, default_value: false, replace_null_with_default: true do
          description <<~TEXT
          When dealing with harvested collections or items, modifying
          the entity within the admin section will cause its
          `harvestModificationStatus` to change to `MODIFIED`, which will
          prevent the harvesting system from overwriting anything within it.

          By setting this option to true, it will force harvested entities to
          remain `PRISTINE`, no matter what changes have been made in the admin
          section. This will allow the harvesting system to overwrite any of
          these changes when next time it runs.

          It must be checked _every_ time the entity is saved in the admin
          section in order to keep the pristine status intact.

          **Note**: It has no effect on `UNHARVESTED` entities.
          TEXT
        end
      end
    end
  end
end
