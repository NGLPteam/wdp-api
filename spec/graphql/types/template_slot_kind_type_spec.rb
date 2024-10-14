# frozen_string_literal: true

RSpec.describe Types::TemplateSlotKindType, type: :graphql_enum do
  it_behaves_like "a database-backed graphql enum", :template_slot_kind
end
