# frozen_string_literal: true

RSpec.describe Access::EnforceAssignmentsJob, type: :job do
  it_behaves_like "a void operation job", "access.enforce_assignments"
end
