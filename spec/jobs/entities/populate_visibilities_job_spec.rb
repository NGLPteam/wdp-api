# frozen_string_literal: true

RSpec.describe Entities::PopulateVisibilitiesJob, type: :job do
  it_behaves_like "a void operation job", "entities.populate_visibilities"
end
