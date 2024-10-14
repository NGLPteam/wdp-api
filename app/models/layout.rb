# frozen_string_literal: true

class Layout < Support::FrozenRecordHelpers::AbstractRecord
  include Dry::Core::Memoizable

  schema!(types: ::Templates::TypeRegistry) do
    required(:layout_kind).filled(:layout_kind)
    required(:template_kinds).filled(:template_kinds)
    required(:description).maybe(:stripped_string)
  end

  default_attributes!(
    description: nil
  )

  self.primary_key = :layout_kind

  add_index :layout_kind, unique: true

  alias_attribute :kind, :layout_kind

  memoize def definition_klass
    definition_klass_name.constantize
  end

  memoize def definition_klass_name
    "layouts/#{layout_kind}_definition".classify
  end

  memoize def instance_klass
    instance_klass_name.constantize
  end

  memoize def instance_klass_name
    "layouts/#{layout_kind}_instance".classify
  end

  # @return [<Template>]
  memoize def templates
    Template.where(layout_kind:).to_a
  end
end
