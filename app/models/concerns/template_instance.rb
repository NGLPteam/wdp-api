# frozen_string_literal: true

module TemplateInstance
  extend ActiveSupport::Concern

  include HasLayoutKind
  include HasTemplateKind
  include Renderable

  included do
    belongs_to :entity, polymorphic: true
  end

  # @!attribute [r] all_slots_empty
  # @see Templates::SlotMappings::AbstractInstanceSlots#all_empty?
  # @return [Boolean]
  def all_slots_empty
    slots.all_empty?
  end

  alias all_slots_empty? all_slots_empty

  # @!attribute [r] hidden
  # Currently derived from {#hidden_by_empty_slots}.
  # @return [Boolean]
  def hidden
    hidden_by_empty_slots?
  end

  alias hidden? hidden

  # @!attribute [r] hidden_by_empty_slots
  # @return [Boolean]
  def hidden_by_empty_slots
    slots.hides_template?
  end

  alias hidden_by_empty_slots? hidden_by_empty_slots
end
