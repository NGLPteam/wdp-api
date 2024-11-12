# frozen_string_literal: true

module Templates
  module Slots
    module Definitions
      class Abstract < ::Templates::Slots::Abstract
        attribute :raw_template, :string

        # @see Templates::Slots::Render
        # @see Templates::Slots::Renderer
        # @param [{ String => Assigns }]
        # @param [Boolean] force
        # @return [Dry::Monads::Success(Templates::Slots::Instances::Abstract)]
        def render(assigns: {}, force: false)
          MeruAPI::Container["templates.slots.render"].(raw_template, assigns:, force:, kind:)
        end

        # @return [String, nil]
        def export_value
          raw_template
        end
      end
    end
  end
end
