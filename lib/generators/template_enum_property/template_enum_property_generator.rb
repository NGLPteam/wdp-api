# frozen_string_literal: true

class TemplateEnumPropertyGenerator < Rails::Generators::NamedBase
  source_root File.expand_path("templates", __dir__)

  # @return [void]
  def generate_gql!
    template "gql_type.rb", template_enum_property.gql_type_path_name
  end

  def generate_config_prop!
    root = Rails.root.join("app", "services", "templates", "config", "properties")
    path = root.join("#{file_name}.rb")

    template "config_prop.rb", path
  end

  def generate_spec!
    path = Rails.root.join("spec", "graphql", "types", "#{file_name}_spec.rb")

    template "spec.rb", path
  end

  private

  def heredoc_description_for(value)
    [
      "<<~TEXT",
      template_enum_property.scoped_description_for(value).strip,
      "TEXT"
    ].compact_blank.join("\n").indent(6).strip
  end

  def template_enum_property
    @template_enum_property ||= TemplateEnumProperty.find file_name
  end
end
