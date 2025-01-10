# frozen_string_literal: true

module Templates
  module Slots
    module Definitions
      class Abstract < ::Templates::Slots::Abstract
        attribute :hide_when_empty, :boolean, default: false

        attribute :raw_template, :string

        # @see Templates::Slots::Render
        # @see Templates::Slots::Renderer
        # @param [{ String => Assigns }]
        # @param [Boolean] force
        # @return [Dry::Monads::Success(Templates::Slots::Instances::Abstract)]
        def render(assigns: {}, force: false)
          MeruAPI::Container["templates.slots.render"].(raw_template, assigns:, force:, kind:, hide_when_empty:)
        end

        # @return [Hash]
        def export_value
          {
            hide_when_empty:,
            raw_template:,
          }.compact_blank
        end
      end
    end
  end
end
