# frozen_string_literal: true

class TemplateGenerator < Rails::Generators::NamedBase
  source_root File.expand_path("templates", __dir__)

  class_option :layout_kind, type: :string

  MODELS = Rails.root.join("app", "models", "templates")

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

  private

  def heredoc_description_for(text)
    [
      "<<~TEXT",
      text,
      "TEXT"
    ].compact_blank.join("\n").indent(8).strip
  end

  def layout_kind
    @layout_kind ||= options.fetch(:layout_kind) do
      template_kind.in?(::Layouts::Types::Kind) ? template_kind : "main"
    end
  end

  def template_kind
    @template_kind ||= class_name.underscore
  end

  def enum_props
    template_properties.select(&:any_enum?)
  end

  def ordering_definition_props
    template_properties.select(&:ordering_definition?)
  end

  def enum_property_declaration_for(prop)
    parts = [
      "pg_enum! ",
      prop.name.to_sym.inspect,
      ", as: ",
      prop.enum_property.name.to_sym.inspect,
      ", allow_blank: false",
      ", suffix: ",
      prop.name.to_sym.inspect,
    ]

    if prop.enum_property.default.present?
      parts << ", default: " << prop.enum_property.default.inspect
    end

    parts.join
  end

  def ordering_property_declaration_for(prop)
    %[attribute #{prop.name.to_sym.inspect}, ::Schemas::Orderings::Definition.to_type]
  end

  def definition_property_declarations
    @definition_property_declarations ||= [].tap do |decl|
      enum_props.each do |prop|
        decl << enum_property_declaration_for(prop)
      end

      ordering_definition_props.each do |prop|
        decl << ordering_property_declaration_for(prop)
      end
    end.join("\n\n").indent(4)
  end

  def template_properties
    @template_properties ||= TemplateProperty.for_template(template_kind).to_a
  end
end
