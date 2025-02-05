# frozen_string_literal: true

module Templates
  module Slots
    module Instances
      # @abstract
      class Abstract < ::Templates::Slots::Abstract
        attribute :hides_template, :boolean, default: false

        attribute :content, :string

        attribute :empty, :boolean, default: false

        attribute :rendered, :boolean, default: false

        # @return [String, nil]
        def export_value
          content if rendered?
        end
      end
    end
  end
end
