# frozen_string_literal: true

module TemplateDefinition
  extend ActiveSupport::Concern
  extend DefinesMonadicOperation

  include HasLayoutKind
  include HasTemplateKind

  # @see Templates::Renderer
  # @return [Dry::Monads::Success(TemplateInstance)]
  monadic_matcher! def render(...)
    call_operation("templates.render", self, ...)
  end
end
