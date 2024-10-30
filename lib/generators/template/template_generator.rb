# frozen_string_literal: true

using ::Templates::Refinements::TemplateGenerator

class TemplateGenerator < Rails::Generators::NamedBase
  source_root File.expand_path("templates", __dir__)

  class_option :layout_kind, type: :string

  MODELS = Rails.root.join("app", "models", "templates")

  CONFIG_ROOT = Rails.root.join("app", "services", "templates", "config")

  TEMPLATE_CONFIG_ROOT = CONFIG_ROOT.join("template")

  SLOTS_CONFIG_ROOT = CONFIG_ROOT.join("template_slots")

  def generate_definition!
    template "definition.rb", MODELS.join("#{file_name}_definition.rb")
  end

  def generate_instance!
    template "instance.rb", MODELS.join("#{file_name}_instance.rb")
  end

  def generate_slot_mappings!
    slot_mappings = Rails.root.join("app", "services", "templates", "slot_mappings")

    template "definition_slots.rb", slot_mappings.join("#{file_name}_definition_slots.rb")
    template "instance_slots.rb", slot_mappings.join("#{file_name}_instance_slots.rb")
  end

  def generate_gql!
    templates = Rails.root.join("app", "graphql", "types", "templates")

    template "gql/definition.rb", templates.join("#{file_name}_template_definition_type.rb")
    template "gql/definition_slots.rb", templates.join("#{file_name}_template_definition_slots_type.rb")
    template "gql/instance.rb", templates.join("#{file_name}_template_instance_type.rb")
    template "gql/instance_slots.rb", templates.join("#{file_name}_template_instance_slots_type.rb")
  end

  def generate_config!
    template "config/template.rb", TEMPLATE_CONFIG_ROOT.join("#{file_name}.rb")

    template "config/slots.rb", SLOTS_CONFIG_ROOT.join("#{file_name}_slots.rb")
  end

  private

  def heredoc_description_for(text)
    [
      "<<~TEXT",
      text&.strip,
      "TEXT"
    ].compact_blank.join("\n").indent(8).strip
  end

  def layout_kind
    @layout_kind ||= options.fetch(:layout_kind) do
      template_kind.in?(::Layouts::Types::Kind) ? template_kind : "main"
    end
  end

  # @return [::Layout]
  def layout_record
    @layout_record ||= template_record.layout
  end

  def template_kind
    @template_kind ||= class_name.underscore
  end

  def template_properties
    @template_properties ||= TemplateProperty.for_template(template_kind).to_a
  end

  # @return [::Template]
  def template_record
    @template_record ||= ::Template.find template_kind
  end

  # @!group Definition Model

  def definition_model_declarations(...)
    template_record.definition_model_declarations(...)
  end

  # @!endgroup

  # @!group Template Config

  def config_shale_attribute_declarations(...)
    template_record.config_shale_attribute_declarations(...)
  end

  def config_shale_xml_mapper_declarations(...)
    template_record.config_shale_xml_mapper_declarations(...)
  end

  # @!endgroup

  # @!group Slot Config

  def slot_config_shale_attribute_declarations(...)
    template_record.slot_config_shale_attribute_declarations(...)
  end

  def slot_config_shale_xml_mapper_declarations(...)
    template_record.slot_config_shale_xml_mapper_declarations(...)
  end

  # @!endgroup
end
