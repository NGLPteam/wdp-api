# frozen_string_literal: true

module HasTemplateKinds
  extend ActiveSupport::Concern

  included do
    extend Dry::Core::ClassAttributes

    defines :template_kinds, type: Templates::Types::Array.of(::Templates::Types::Kind)

    template_kinds [].freeze
  end

  module ClassMethods
    def template_kinds!(*kinds)
      template_kinds kinds.flatten.map(&:to_s).uniq.freeze
    end
  end
end
