# frozen_string_literal: true

class LayoutGenerator < Rails::Generators::NamedBase
  source_root File.expand_path("templates", __dir__)

  MODELS = Rails.root.join("app", "models", "layouts")

  def generate_definition!
    template "definition.rb", MODELS.join("#{file_name}_definition.rb")
  end

  def generate_instance!
    template "instance.rb", MODELS.join("#{file_name}_instance.rb")
  end

  def generate_unions!
    template "gql/definition_union.rb", Rails.root.join("app", "graphql", "types", "any_#{file_name}_template_definition_type.rb")
    template "gql/instance_union.rb", Rails.root.join("app", "graphql", "types", "any_#{file_name}_template_instance_type.rb")
  end

  def generate_gql!
    template "gql/definition.rb", Rails.root.join("app", "graphql", "types", "layouts", "#{file_name}_layout_definition_type.rb")
    template "gql/instance.rb", Rails.root.join("app", "graphql", "types", "layouts", "#{file_name}_layout_instance_type.rb")
  end

  def generate_config!
    root = Rails.root.join("app", "services", "templates", "config")

    layout_path = root.join("layout", "#{file_name}.rb")

    templates_path = root.join("layout_templates", "#{file_name}_templates.rb")

    template "config/layout.rb", layout_path

    template "config/templates.rb", templates_path
  end

  private

  def has_single_template?
    template_kinds.one?
  end

  def layout_kind
    @layout_kind ||= class_name.underscore
  end

  def layout_record
    @layout_record ||= ::Layout.find(layout_kind)
  end

  def template_kinds
    @template_kinds ||= Layouts::Types::TemplateMapping.fetch(layout_kind)
  end
end
