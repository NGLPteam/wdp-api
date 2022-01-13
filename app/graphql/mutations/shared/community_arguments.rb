# frozen_string_literal: true

module Mutations
  module Shared
    module CommunityArguments
      extend ActiveSupport::Concern

      include Mutations::Shared::EntityArguments

      included do
        argument :hero_image_layout, Types::HeroImageLayoutType, required: true, attribute: true
        argument :tagline, String, required: false, attribute: true

        image_attachment! :logo
      end
    end
  end
end
