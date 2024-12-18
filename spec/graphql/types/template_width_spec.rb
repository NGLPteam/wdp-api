# frozen_string_literal: true

RSpec.describe Types::TemplateWidthType, type: :graphql_enum do
  it_behaves_like "a database-backed graphql enum", :template_width
end
