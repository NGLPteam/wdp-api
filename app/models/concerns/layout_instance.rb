# frozen_string_literal: true

module LayoutInstance
  extend ActiveSupport::Concern
  extend DefinesMonadicOperation

  include HasLayoutKind
  include HasTemplateKinds
  include Renderable

  included do
    extend Dry::Core::ClassAttributes

    belongs_to :entity, polymorphic: true

    defines :template_instance_names, type: Layouts::Types::Associations

    template_instance_names [].freeze

    scope :with_template_instances, -> { includes(*template_instance_names) }

    validates :generation, presence: true
  end

  # @return [<Symbol>]
  def template_instance_names
    self.class.template_instance_names
  end

  # @return [<TemplateInstance>]
  def template_instances
    template_instance_names.map do |assoc|
      __send__(assoc).to_a
    end.reduce(&:+).sort_by(&:position)
  end

  module ClassMethods
    # @param [HierarchicalEntity] entity
    # @param [LayoutDefinition] layout_definition
    # @return [LayoutInstance]
    def fetch_for(entity, layout_definition:, generation: SecureRandom.uuid)
      where(entity:).first_or_initialize do |li|
        li.generation = generation
        li.layout_definition = layout_definition
      end
    end

    def template_kinds!(...)
      super

      template_instance_names template_kinds.map { :"#{_1}_template_instances" }
    end
  end
end
