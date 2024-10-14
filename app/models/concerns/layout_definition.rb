# frozen_string_literal: true

module LayoutDefinition
  extend ActiveSupport::Concern
  extend DefinesMonadicOperation

  include HasLayoutKind
  include HasTemplateKinds

  included do
    extend Dry::Core::ClassAttributes

    defines :template_definition_names, type: Layouts::Types::Associations

    template_definition_names [].freeze

    scope :root, -> { where(entity_type: nil, entity_id: nil) }
    scope :leaf, -> { where(arel_table[:entity_type].not_eq(nil).and(arel_table[:entity_id].not_eq(nil))) }

    scope :with_template_definitions, -> { includes(*template_definition_names) }
  end

  # @see Layouts::Renderer
  # @return [Dry::Monads::Success(TemplateInstance)]
  monadic_matcher! def render(...)
    call_operation("layouts.render", self, ...)
  end

  # @return [<Symbol>]
  def template_definition_names
    self.class.template_definition_names
  end

  # @return [<TemplateDefinition>]
  def template_definitions
    template_definition_names.map do |assoc|
      __send__(assoc).to_a
    end.reduce(&:+).sort_by(&:position)
  end

  module ClassMethods
    def template_kinds!(...)
      super

      names = template_kinds.map { :"#{_1}_template_definitions" }

      template_definition_names names
    end
  end
end
