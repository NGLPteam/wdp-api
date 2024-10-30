# frozen_string_literal: true

# @see Templates::ManualListEntry
module ManualListTarget
  extend ActiveSupport::Concern

  included do
    has_many :incoming_manual_list_entries,
      class_name: "Templates::ManualListEntry",
      as: :target,
      dependent: :destroy
  end
end
