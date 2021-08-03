# frozen_string_literal: true

module HasSchemaDefinition
  extend ActiveSupport::Concern

  included do
    belongs_to :schema_definition
    belongs_to :schema_version

    has_many :schematic_collected_references, -> { in_order.preload(:referent) }, as: :referrer, dependent: :destroy, inverse_of: :referrer do
      # @return [{ String => <ApplicationRecord>, nil }]
      def to_reference_map
        each_with_object({}) do |ref, h|
          h[ref.path] ||= []

          h[ref.path] << ref.referent
        end
      end
    end

    has_many :schematic_scalar_references, -> { preload(:referent) }, as: :referrer, dependent: :destroy, inverse_of: :referrer do
      # @return [{ String => ApplicationRecord, nil }]
      def to_reference_map
        each_with_object({}) do |ref, h|
          h[ref.path] = ref.referent
        end
      end
    end

    attribute :properties, Schemas::Instances::PropertySet.to_type, default: proc { { values: {} } }

    before_validation :enforce_schema_definition!, if: :schema_version_id_changed?

    delegate :kind, to: :schema_version, prefix: true, allow_nil: true

    validate :enforce_schema_kind!, if: :should_check_schema_kind?
  end

  def apply_properties!(values)
    call_operation("schemas.instances.apply", self, values)
  end

  # @api private
  # @return [void]
  def apply_generated_properties!
    call_operation("schemas.instances.apply_generated_properties", self)
  end

  # @see Schemas::Instances::ReadProperties
  # @return [<Schemas::Properties::Reader, Schemas::Properties::GroupReader>]
  def read_properties
    call_operation("schemas.instances.read_properties", self)
  end

  # @api private
  # @return [void]
  def enforce_schema_definition!
    self.schema_definition_id = schema_version.schema_definition_id
  end

  # @api private
  # @return [void]
  def enforce_schema_kind!
    return if schema_kind_matches?

    errors.add :schema_version_id, "must be #{schema_kind}, got #{schema_version.kind}"
  end

  # @!attribute [r] schema_kind
  # @return ["community", "collection", "item"]
  def schema_kind
    model_name.singular
  end

  # Checks {#schema_kind} against {SchemaVersion#kind}.
  def schema_kind_matches?
    schema_kind == schema_version_kind.to_s
  end

  # @api private
  def should_check_schema_kind?
    new_record? || schema_version_id_changed?
  end
end
