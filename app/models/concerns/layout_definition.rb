# frozen_string_literal: true

module LayoutDefinition
  extend ActiveSupport::Concern
  extend DefinesMonadicOperation

  include HasLayoutKind
  include HasTemplateKinds

  included do
    extend Dry::Core::ClassAttributes

    has_many :entity_derived_layout_definitions, as: :layout_definition, inverse_of: :layout_definition, dependent: :delete_all

    has_many_readonly :entity_missing_layout_definitions, as: :layout_definition, inverse_of: :layout_definition

    has_many_readonly :entity_missing_template_definitions, as: :layout_definition, inverse_of: :layout_definition

    has_one :layout_definition_hierarchy, as: :layout_definition, inverse_of: :layout_definition, dependent: :delete

    has_many :instance_digests, as: :layout_definition, inverse_of: :layout_definition, class_name: "Layouts::InstanceDigest", dependent: :delete_all

    has_many :manual_lists,
      class_name: "Templates::ManualList",
      as: :layout_definition,
      dependent: :destroy

    has_many :rendering_layout_logs, as: :layout_definition, inverse_of: :layout_definition, class_name: "Rendering::LayoutLog", dependent: :delete_all

    has_many :rendering_template_logs, as: :layout_definition, inverse_of: :layout_definition, class_name: "Rendering::TemplateLog", dependent: :delete_all

    has_many :template_definition_digests, as: :layout_definition, inverse_of: :layout_definition, class_name: "Templates::DefinitionDigest", dependent: :delete_all

    has_many :template_instance_digests, as: :layout_definition, inverse_of: :layout_definition, class_name: "Templates::InstanceDigest", dependent: :delete_all

    defines :template_definition_names, type: Layouts::Types::Associations

    template_definition_names [].freeze

    delegate :policy_class, to: :class

    scope :root, -> { where(entity_type: nil, entity_id: nil) }
    scope :leaf, -> { where(arel_table[:entity_type].not_eq(nil).and(arel_table[:entity_id].not_eq(nil))) }

    scope :with_template_definitions, -> { includes(*template_definition_names) }

    after_save :upsert_hierarchy!
  end

  # @see Layouts::Config::Exporter
  # @return [Dry::Monads::Success(Templates::Config::Utility::AbstractLayout)]
  monadic_matcher! def export(...)
    call_operation("layouts.config.export", self, ...)
  end

  # @see Layouts::Definitions::Invalidate
  # @see Layouts::Definitions::Invalidator
  monadic_matcher! def invalidate_instances(...)
    call_operation("layouts.definitions.invalidate", self, ...)
  end

  # @see Layouts::Renderer
  # @return [Dry::Monads::Success(LayoutInstance)]
  monadic_matcher! def render(...)
    call_operation("layouts.render", self, ...)
  end

  # @see Layouts::DefinitionHierarchies::Upsert
  # @see Layouts::DefinitionHierarchies::Upserter
  # @return [Dry::Monads::Success(void)]
  monadic_operation! def upsert_hierarchy
    call_operation("layouts.definition_hierarchies.upsert", self)
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
    def policy_class
      LayoutDefinitionPolicy
    end

    def template_kinds!(...)
      super

      names = template_kinds.map { :"#{_1}_template_definitions" }

      template_definition_names names
    end
  end
end
