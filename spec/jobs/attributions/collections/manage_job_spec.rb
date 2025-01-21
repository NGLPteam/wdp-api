# frozen_string_literal: true

RSpec.describe Attributions::Collections::ManageJob, type: :job do
  it_behaves_like "a void operation job", "attributions.collections.manage"
end
