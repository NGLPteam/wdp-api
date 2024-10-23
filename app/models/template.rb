# frozen_string_literal: true

class Template < Support::FrozenRecordHelpers::AbstractRecord
  include Dry::Core::Memoizable

  schema!(types: ::Templates::TypeRegistry) do
    required(:template_kind).filled(:template_kind)
    required(:layout_kind).filled(:layout_kind)
    required(:description).maybe(:stripped_string)
    required(:has_background).value(:bool)
    required(:has_variant).value(:bool)
  end

  default_attributes!(
    description: nil,
    has_background: true,
    has_variant: false,
  )

  TEMPLATING_ROOT = Rails.root.join("lib", "templating")

  self.primary_key = :template_kind

  add_index :template_kind, unique: true

  alias_attribute :kind, :template_kind

  memoize def definition_klass
    definition_klass_name.constantize
  end

  memoize def definition_klass_name
    "templates/#{template_kind}_definition".classify
  end

  memoize def instance_klass
    instance_klass_name.constantize
  end

  memoize def instance_klass_name
    "templates/#{template_kind}_instance".classify
  end

  # @return [Layout]
  memoize def layout
    Layout.find layout_kind
  end

  # @!group Definitions

  # @return [void]
  def check_definitions!
    definitions_root.mkpath

    slot_definitions_root.mkpath

    models = model_validator

    unless models.valid?
      models.errors.full_messages.each do |msg|
        warn msg
      end
    end
  end

  # @return [Templates::Validators::ModelValidator]
  def model_validator
    Templates::Validators::ModelValidator.new(self)
  end

  memoize def definitions_root
    TEMPLATING_ROOT.join("definitions", template_kind)
  end

  memoize def config_definition
    raw_content = config_definition_path.read

    ::Templates::Definitions::Configuration.from_xml(raw_content).tap do |config|
      config.template_kind = template_kind
    end
  end

  memoize def defined_props
    config_definition.props
  end

  memoize def defined_prop_names
    defined_props.map(&:name).sort
  end

  memoize def defined_prop_kinds
    defined_props.map(&:kind).tally
  end

  memoize def config_definition_path
    definitions_root.join("config.xml")
  end

  memoize def slot_definitions_root
    definitions_root.join("slots")
  end

  # @return [<Templates::Definitions::Slot>]
  memoize def slot_definitions
    slot_definitions_root.glob("*.xml").map do |path|
      content = path.read

      name = path.basename(".xml").to_s

      ::Templates::Definitions::Slot.from_xml(content).tap do |definition|
        definition.name = name
        definition.template_kind = template_kind
      end
    end
  end

  # @!endgroup

  class << self
    # @return [void]
    def check_definitions!
      each(&:check_definitions!)
    end

    # @return [<Hash>]
    def derive_properties
      Template.order(template_kind: :asc).each_with_object([]) do |tpl, props|
        base = { template_kind: tpl.template_kind }.stringify_keys

        tpl.defined_props.each do |prop|
          props << base.merge(prop.to_record)
        end
      end
    end

    # @return [String]
    def derive_properties_yaml
      derive_properties.to_yaml
    end
  end
end
