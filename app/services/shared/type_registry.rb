# frozen_string_literal: true

module Shared
  # The shared type registry used by {ApplicationContract}.
  TypeRegistry = Dry::Schema::TypeContainer.new

  TypeRegistry.register "params.safe_string", Dry::Types["coercible.string"]
  TypeRegistry.register "json.safe_string", Dry::Types["coercible.string"]
end
