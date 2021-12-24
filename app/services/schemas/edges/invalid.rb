# frozen_string_literal: true

module Schemas
  module Edges
    # An invalid {Schemas::Edges::Edge}.
    class Invalid < Dry::Struct
      attribute :parent, Schemas::Types::Kind
      attribute :child, Schemas::Types::Kind
    end
  end
end
