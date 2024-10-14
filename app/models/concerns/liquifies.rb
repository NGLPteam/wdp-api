# frozen_string_literal: true

module Liquifies
  extend ActiveSupport::Concern

  included do
    extend Dry::Core::ClassAttributes

    defines :drop_klass, type: Templates::Types.Inherits(Templates::Drops::AbstractDrop)
  end

  # @return [Templates::Drops::AbstractDrop]
  def to_liquid
    self.class.drop_klass.new(self)
  end
end
