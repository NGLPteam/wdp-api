# frozen_string_literal: true

module TemplateDefinition
  extend ActiveSupport::Concern
  extend DefinesMonadicOperation

  include HasLayoutKind
  include HasTemplateKind

  included do
    attribute :config, Templates::Definitions::Config.to_type

    has_one :definition_digest, as: :template_definition, inverse_of: :template_definition, class_name: "Templates::DefinitionDigest", dependent: :delete

    has_many_readonly :entity_missing_template_definitions, as: :template_definition, inverse_of: :template_definition

    has_many :instance_digests, as: :template_definition, inverse_of: :template_definition, class_name: "Templates::InstanceDigest", dependent: :delete_all

    has_many :rendering_template_logs, as: :template_definition, class_name: "Rendering::TemplateLog", dependent: :delete_all

    scope :sans_positions, ->(*positions) do
      positions.flatten!.uniq!

      next all if positions.blank?

      where.not(position: positions)
    end

    delegate :policy_class, to: :class

    before_validation :infer_config!

    after_save :upsert_digest!
  end

  # @see Templates::Definitions::BuildConfig
  # @see Templates::Definitions::ConfigBuilder
  monadic_operation! def build_config
    call_operation("templates.definitions.build_config", self)
  end

  monadic_matcher! def export(...)
    call_operation("templates.config.export", self, ...)
  end

  # @return [{ String => Object }]
  def export_properties
    slice(*template_record.property_names_for_configuration)
      .transform_values(&:as_json)
      .deep_stringify_keys
  end

  # @see Templates::SlotMappings::AbstractSlots#export
  # @return [{ String => String, nil }]
  def export_slots
    slots.export
  end

  # @see Templates::Renderer
  # @return [Dry::Monads::Success(TemplateInstance)]
  monadic_matcher! def render(...)
    call_operation("templates.render", self, ...)
  end

  monadic_operation! def render_slots(entity:)
    call_operation("templates.definitions.render_slots", self, entity)
  end

  monadic_operation! def upsert_digest
    call_operation("templates.digests.definitions.upsert", self)
  end

  private

  # @return [void]
  def infer_config!
    self.config = build_config!
  end

  module ClassMethods
    def policy_class
      TemplateDefinitionPolicy
    end
  end
end
