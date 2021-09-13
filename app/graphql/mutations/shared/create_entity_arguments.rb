# frozen_string_literal: true

module Mutations
  module Shared
    module CreateEntityArguments
      extend ActiveSupport::Concern

      include Mutations::Shared::EntityArguments
    end
  end
end
