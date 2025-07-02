# frozen_string_literal: true

RSpec.describe Entities::DeriveLayoutDefinitionsJob, type: :job do
  it_behaves_like "a void operation job", "entities.derive_layout_definitions"
end
