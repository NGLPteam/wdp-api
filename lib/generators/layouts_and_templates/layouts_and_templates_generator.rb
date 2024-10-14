# frozen_string_literal: true

class LayoutsAndTemplatesGenerator < Rails::Generators::Base
  source_root File.expand_path("templates", __dir__)

  MODEL_CONCERNS = Rails.root.join("app", "models", "concerns")

  def generate_layouts_and_templates!
    layout_kinds.each do |layout_kind|
      generate_layout!(layout_kind:)
    end
  end

  def generate_model_concerns!
    template "entity_concern.rb", MODEL_CONCERNS.join("entity_templating.rb")
    template "schema_version_concern.rb", MODEL_CONCERNS.join("schema_version_templating.rb")
  end

  def generate_gql_layouts!
    template "gql/entity_layouts.rb", Rails.root.join("app", "graphql", "types", "entity_layouts_type.rb")
  end

  def write_layout_records!
    records = layout_kinds.map do |layout_kind|
      template_kinds = ::Layouts::Types::TemplateMapping.fetch(layout_kind)

      { layout_kind:, template_kinds:, }.stringify_keys
    end

    create_file Rails.root.join("lib", "frozen_record", "layouts.yml"), YAML.dump(records)
  end

  def write_template_records!
    records = ::Layouts::Types::TemplateMapping.flat_map do |(layout_kind, template_kinds)|
      template_kinds.map do |template_kind|
        { template_kind:, layout_kind:, }.stringify_keys
      end
    end

    create_file Rails.root.join("lib", "frozen_record", "templates.yml"), YAML.dump(records)
  end

  private

  def layout_kinds
    @layout_kinds ||= ApplicationRecord.pg_enum_values(:layout_kind)
  end

  def template_kinds
    @template_kinds ||= ApplicationRecord.pg_enum_values(:template_kind)
  end

  def generate_layout!(layout_kind:)
    args = [layout_kind, "--layout-kind", layout_kind]

    args << "--force" if options[:force]

    Rails::Generators.invoke("layout", args)

    templates = ::Layouts::Types::TemplateMapping.fetch(layout_kind)

    templates.each do |template_kind|
      generate_template!(template_kind:, layout_kind:)
    end
  end

  def generate_template!(template_kind:, layout_kind:)
    args = [template_kind, "--layout-kind", layout_kind]

    args << "--force" if options[:force]

    Rails::Generators.invoke("template", args)
  end
end
