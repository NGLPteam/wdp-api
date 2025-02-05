# frozen_string_literal: true

module Mutations
  extend Dry::Core::ClassAttributes

  defines :active, type: ::Support::Types.Instance(::Mutations::Active)

  active Mutations::Active.new

  class << self
    # @see MutationModelSupport
    # @see Mutations::Active
    # @return [void]
    def with_active!(&)
      active.wrap!(&)
    end
  end
end
