# frozen_string_literal: true

module Schemas
  module Associations
    class NamedAncestor < Association
      include Dry::Core::Equalizer.new :name, inspect: false

      attribute :name, :string
      attribute :required, :boolean, default: proc { false }
    end
  end
end
