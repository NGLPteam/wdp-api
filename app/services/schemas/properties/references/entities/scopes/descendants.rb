# frozen_string_literal: true

module Schemas
  module Properties
    module References
      module Entities
        module Scopes
          class Descendants < Base
            include HasOrigin

            attribute :depth, :integer

            validates :depth, numericality: { allow_nil: true, integer_only: true, greater_than: 0 }
          end
        end
      end
    end
  end
end
