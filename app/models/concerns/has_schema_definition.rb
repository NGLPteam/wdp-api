# frozen_string_literal: true

module HasSchemaDefinition
  extend ActiveSupport::Concern

  included do
    belongs_to :schema_definition
    belongs_to :schema_version

    has_many :schematic_collected_references, -> { with_valid_path.in_order.preload(:referent) }, as: :referrer, dependent: :destroy, inverse_of: :referrer do
      # @return [{ String => <ApplicationRecord>, nil }]
      def to_reference_map
        each_with_object({}) do |ref, h|
          h[ref.path] ||= []

          next if ref.referent.blank?

          h[ref.path] << ref.referent
        end
      end
    end

    has_many :schematic_scalar_references, -> { with_valid_path.preload(:referent) }, as: :referrer, dependent: :destroy, inverse_of: :referrer do
      # @return [{ String => ApplicationRecord, nil }]
      def to_reference_map
        each_with_object({}) do |ref, h|
          next if ref.referent.blank?

          h[ref.path] = ref.referent
        end
      end
    end

    has_many :schematic_texts, -> { with_valid_path }, as: :entity, dependent: :destroy, inverse_of: :entity do
      # @return [{ String => FullTextContent, nil }]
      def to_reference_map
        each_with_object({}) do |text, h|
          next if text.content.blank?

          h[text.path] = text.to_reference
        end
      end
    end

    has_many :entity_orderable_properties, as: :entity, dependent: :destroy

    attribute :properties, Schemas::Instances::PropertySet.to_type, default: proc { { values: {} } }

    before_validation :enforce_schema_definition!, if: :schema_version_id_changed?
    before_validation :maybe_sign_properties!

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
  def alter_version!(schema_version, new_values, strategy: :apply)
    call_operation("schemas.instances.alter_version", self, schema_version, new_values, strategy: strategy)
  end

  # @param [SchemaVersion] schema_version
  # @param [Hash] new_values
  # @return [Dry::Monads::Result]
  def alter_version_only!(schema_version)
    call_operation("schemas.instances.alter_version", self, schema_version, {}, strategy: :skip)
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

  # @see Schemas::Instances::ExtractOrderableProperties
  # @param [Schemas::Properties::Context, nil] context
  # @return [void]
  def extract_orderable_properties!(context: nil)
    call_operation("schemas.instances.extract_orderable_properties", self, context: context).value!
  end

  # @return [String]
  def inspect
    schema_suffix = properties&.schema&.suffix

    "#<#{self.class}#{schema_suffix} (#{title.inspect})>"
  end

  # @see Schemas::Instances::ReadProperties
  # @param [Schemas::Properties::Context, nil] context
  # @return [<Schemas::Properties::Reader, Schemas::Properties::GroupReader>]
  def read_properties(context: nil)
    call_operation("schemas.instances.read_properties", self, context: context)
  end

  # @see Schemas::Instances::ReadProperty
  # @param [String] full_path
  # @param [Schemas::Properties::Context, nil] context
  # @return [Dry::Monads::Success(Schemas::Properties::Reader)]
  # @return [Dry::Monads::Success(Schemas::Properties::GroupReader)]
  # @return [Dry::Monads::Failure(Symbol, String)]
  def read_property(full_path, context: nil)
    call_operation("schemas.instances.read_property", self, full_path, context: context)
  end

  def read_property!(full_path, context: nil)
    read_property(full_path, context: context).value!
  end

  # @note For testing use only
  # @api private
  # @see Schemas::Instances::ReadPropertyContext
  # @return [Schema::Properties::Context]
  def read_property_context
    call_operation("schemas.instances.read_property_context", self).value!
  end

  # @see #read_property
  # @param [String] full_path
  # @param [Schemas::Properties::Context, nil] context
  # @return [Dry::Monads::Result]
  def read_property_value(full_path, context: nil)
    read_property(full_path, context: context).tee(&:must_be_scalar).fmap(&:value)
  end

  # @see #read_property_value
  # @param [String] full_path
  # @param [Schemas::Properties::Context, nil] context
  # @return [Dry::Monads::Result]
  def read_property_value!(full_path, context: nil)
    read_property_value(full_path, context: context).value!
  end

  # @see Schema::Properties::Context#field_values
  # @return [Hash]
  def read_property_values!
    read_property_context.field_values
  end

  # @see Schemas::Instances::Validate
  # @return [Hash]
  def validate_schema_properties(context: nil)
    call_operation("schemas.instances.validate", self, context: context).value!
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

  # @api private
  # @return [void]
  def maybe_sign_properties!
    return if properties&.schema&.valid?

    self.properties ||= {}
    self.properties.schema = schema_version.to_header

    properties_will_change!
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

  def to_entity_pair
    slice(:entity_type).merge(entity_id: id)
  end
end
