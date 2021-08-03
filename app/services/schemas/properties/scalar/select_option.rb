# frozen_string_literal: true

module Schemas
  module Properties
    module Scalar
      class SelectOption
        include StoreModel::Model

        attribute :label, :string
        attribute :value, :string
      end
    end
  end
end
