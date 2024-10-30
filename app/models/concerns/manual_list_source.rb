# frozen_string_literal: true

# @see Templates::ManualListEntry
module ManualListSource
  extend ActiveSupport::Concern
  extend DefinesMonadicOperation

  included do
    has_many :manual_list_entries,
      -> { in_default_order.includes(:target) },
      class_name: "Templates::ManualListEntry",
      as: :source,
      inverse_of: :source,
      dependent: :destroy
  end

  # @see Templates::ManualLists::Assign
  # @see Templates::ManualLists::Assigner
  # @return [Dry::Monads::Success{ Symbol => Integer }]
  monadic_operation! def manual_list_assign(list_name:, template_kind:, targets: [])
    call_operation("templates.manual_lists.assign", self, list_name:, template_kind:, targets:)
  end
end
