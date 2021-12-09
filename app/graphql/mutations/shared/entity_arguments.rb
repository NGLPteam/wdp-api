# frozen_string_literal: true

module Mutations
  module Shared
    module EntityArguments
      extend ActiveSupport::Concern

      included do
        argument :title, String, required: true, description: "Human readable title for the entity", attribute: true

        image_attachment! :hero_image

        image_attachment! :thumbnail
      end
    end
  end
end
