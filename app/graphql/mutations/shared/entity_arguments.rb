# frozen_string_literal: true

module Mutations
  module Shared
    module EntityArguments
      extend ActiveSupport::Concern

      included do
        argument :title, String, required: true, description: "Human-readable title for the entity", attribute: true

        argument :subtitle, String, required: false, description: "Human-readable subtitle for the entity", attribute: true

        argument :summary, String, required: false,
          description: "A brief description of the entity's contents.",
          attribute: true

        image_attachment! :hero_image

        image_attachment! :thumbnail
      end
    end
  end
end
