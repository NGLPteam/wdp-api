# frozen_string_literal: true

class TemplateEnumPropertiesGenerator < Rails::Generators::Base
  source_root File.expand_path("templates", __dir__)

  # @return [void]
  def generate_each_template_enum_property!
    TemplateEnumProperty.each do |enum_property|
      args = [enum_property.name]

      args << "--force" if options[:force]

      Rails::Generators.invoke("template_enum_property", args)
    end
  end
end
