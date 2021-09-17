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

          next if ref.referent.blank?

          h[ref.path] << ref.referent
        end
      end
    end

    has_many :schematic_scalar_references, -> { preload(:referent) }, as: :referrer, dependent: :destroy, inverse_of: :referrer do
      # @return [{ String => ApplicationRecord, nil }]
      def to_reference_map
        each_with_object({}) do |ref, h|
          next if ref.referent.blank?

          h[ref.path] = ref.referent
        end
      end
    end

    attribute :properties, Schemas::Instances::PropertySet.to_type, default: proc { { values: {} } }

    before_validation :enforce_schema_definition!, if: :schema_version_id_changed?

    delegate :kind, to: :schema_version, prefix: true, allow_nil: true

    validate :enforce_schema_kind!, if: :should_check_schema_kind?
  end

  # Enqueues a {Schemas::Instances::AlterAndGenerateJob} to asynchronously
  # alter the schema for a schema instance.
  #
  # @param [SchemaVersion] schema_version
  # @return [void]
  def asynchronously_alter_and_generate!(schema_version)
    Schemas::Instances::AlterAndGenerateJob.perform_later self, schema_version
  end

  # @param [SchemaVersion] schema_version
  # @return [Dry::Monads::Result]
  def alter_and_generate!(schema_version)
    call_operation("schemas.instances.alter_and_generate", self, schema_version)
  end

  # @param [SchemaVersion] schema_version
  # @param [Hash] new_values
  # @return [Dry::Monads::Result]
  def alter_version!(schema_version, new_values)
    call_operation("schemas.instances.alter_version", self, schema_version, new_values)
  end

  # @see Schemas::Instances::Apply
  # @param [Hash] values
  # @return [Dry::Monads::Result]
  def apply_properties!(values)
    call_operation("schemas.instances.apply", self, values)
  end

  # @api private
  # @see Schemas::Instances::ApplyGenerated
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
    return if schema_version_kind.blank? || schema_kind_matches?

    errors.add :schema_version_id, "must be a #{schema_kind}, got #{schema_version_kind}"
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
