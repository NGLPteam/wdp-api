# frozen_string_literal: true

module Schemas
  module Properties
    SchemaTypes = Dry::Schema::TypeContainer.new

    SchemaTypes.register "params.any", Dry::Types["any"]
  end
end
