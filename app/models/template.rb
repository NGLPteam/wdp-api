# frozen_string_literal: true

class Template < Support::FrozenRecordHelpers::AbstractRecord
  include Dry::Core::Memoizable

  schema!(types: ::Templates::TypeRegistry) do
    required(:template_kind).filled(:template_kind)
    required(:layout_kind).filled(:layout_kind)
    required(:description).maybe(:stripped_string)
  end

  default_attributes!(
    description: nil
  )

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
end
