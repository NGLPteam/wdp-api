# frozen_string_literal: true

RSpec.describe Attributions::Items::ManageJob, type: :job do
  it_behaves_like "a void operation job", "attributions.items.manage"
end
