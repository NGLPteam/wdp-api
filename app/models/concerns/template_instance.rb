# frozen_string_literal: true

module TemplateInstance
  extend ActiveSupport::Concern

  include HasLayoutKind
  include HasTemplateKind
  include Renderable

  included do
    belongs_to :entity, polymorphic: true
  end
end
