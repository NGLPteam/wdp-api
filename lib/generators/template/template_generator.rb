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

  def layout_kind
    @layout_kind ||= options.fetch(:layout_kind) do
      template_kind.in?(::Layouts::Types::Kind) ? template_kind : "main"
    end
  end

  def template_kind
    @template_kind ||= class_name.underscore
  end
end
