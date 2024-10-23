# frozen_string_literal: true

class TemplateProperty < Support::FrozenRecordHelpers::AbstractRecord
  include Dry::Core::Memoizable

  schema!(types: ::Templates::TypeRegistry) do
    required(:id).filled(:string)
    required(:template_kind).filled(:template_kind)
    required(:name).filled(:string)
    required(:property_kind_name).filled(:property_kind)
    required(:property_kind).value(Templates::Types.Instance(::TemplatePropertyKind))
    required(:description).maybe(:string)
  end

  default_attributes!(
    description: nil
  )

  calculates_id_from! :template_kind, :name

  calculates! :property_kind do |record|
    ::TemplatePropertyKind.find(record.fetch("property_kind_name"))
  end

  self.primary_key = :id

  add_index :id, unique: true
  add_index :name
  add_index :template_kind

  delegate :any_enum?, to: :property_kind

  scope :for_template, ->(kind) { where(template_kind: kind.to_s) }

  memoize def dry_type
    property_kind.dry_type_for(template_kind)
  end

  # @return [TemplateEnumProperty, nil]
  memoize def enum_property
    property_kind.enum_property_for(template_kind)
  end

  memoize def gql_type_name
    property_kind.gql_type_name_for(template_kind)
  end

  def ordering_definition?
    property_kind_name == "ordering_definition"
  end
end
