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

  def generate_kind_enums!
    template "gql/layout_kind.rb", Rails.root.join("app", "graphql", "types", "layout_kind_type.rb")
    template "gql/template_kind.rb", Rails.root.join("app", "graphql", "types", "template_kind_type.rb")
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
