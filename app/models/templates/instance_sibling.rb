# frozen_string_literal: true

module Templates
  class InstanceSibling < ApplicationRecord
    include Support::Caching::Usage
    include View

    self.primary_key = :template_instance_id

    pg_enum! :kind, as: :sibling_kind, suffix: :sibling
    pg_enum! :layout_kind, as: :layout_kind, suffix: :layout
    pg_enum! :template_kind, as: :template_kind, suffix: :template

    attribute :config, Templates::Digests::Config.to_type

    belongs_to_readonly :template_instance, polymorphic: true
    belongs_to_readonly :sibling_instance, polymorphic: true

    scope :in_prev_order, -> { order(position: :desc) }
    scope :in_next_order, -> { order(position: :asc) }

    scope :with_sibling, -> { includes(:sibling_instance) }

    scope :for_prev, -> { prev_sibling.with_sibling.in_prev_order }
    scope :for_next, -> { next_sibling.with_sibling.in_next_order }

    # @!attribute [r] hidden
    # @return [Boolean]
    def hidden
      vog_cache sibling_instance_id, :hidden do
        sibling_instance.hidden?
      end
    end

    alias hidden? hidden
  end
end
