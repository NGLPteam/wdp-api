# frozen_string_literal: true

module Mutations
  module Shared
    module UpdateEntityArguments
      extend ActiveSupport::Concern

      include Mutations::Shared::EntityArguments

      included do
        clearable_attachment! :hero_image
        clearable_attachment! :thumbnail
      end
    end
  end
end
