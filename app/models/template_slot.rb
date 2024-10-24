# frozen_string_literal: true

class TemplateSlot < Support::FrozenRecordHelpers::AbstractRecord
  include Dry::Core::Memoizable

  schema!(types: ::Templates::TypeRegistry) do
    optional(:id).filled(:string)
    required(:name).filled(:string)
    required(:slot_kind).filled(:slot_kind)
    required(:template_kind).filled(:template_kind)
    required(:default_template).maybe(:stripped_string)
    required(:description).maybe(:stripped_string)
  end

  default_attributes!(
    default_template: nil,
    description: nil
  )

  calculates_id_from! :template_kind, :name

  self.primary_key = :id

  add_index :id, unique: true

  add_index :template_kind

  scope :for_template, ->(kind) { where(template_kind: kind.to_s) }

  # @return [Template]
  memoize def template
    Template.find template_kind
  end

  def define_slot!
    # :nocov:
    root = template.slot_definitions_root

    file = root.join("#{name}.xml")

    hsh = { slot_kind:, description: { content: description, }, default_template: { content: default_template }, }.deep_stringify_keys

    mapper = ::Templates::Definitions::Slot.from_hash(hsh)

    file.open("wb+") do |f|
      f.write mapper.to_xml(declaration: true, pretty: true)
    end
    # :nocov:
  end
end
