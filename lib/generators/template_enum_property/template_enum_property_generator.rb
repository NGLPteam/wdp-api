# frozen_string_literal: true

class TemplateEnumPropertyGenerator < Rails::Generators::NamedBase
  source_root File.expand_path("templates", __dir__)

  # @return [void]
  def generate_gql!
    template "gql_type.rb", template_enum_property.gql_type_path_name
  end

  private

  def heredoc_description_for(value)
    [
      "<<~TEXT",
      template_enum_property.scoped_description_for(value),
      "TEXT"
    ].compact_blank.join("\n").indent(6).strip
  end

  def template_enum_property
    @template_enum_property ||= TemplateEnumProperty.find file_name
  end

  def template_properties
    @template_properties ||= TemplateProperty.for_template(file_name).to_a
  end
end
