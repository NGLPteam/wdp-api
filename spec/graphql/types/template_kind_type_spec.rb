# frozen_string_literal: true

RSpec.describe Types::TemplateKindType, type: :graphql_enum do
  it_behaves_like "a database-backed graphql enum", :template_kind
end
