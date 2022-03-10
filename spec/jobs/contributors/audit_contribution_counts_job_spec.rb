# frozen_string_literal: true

RSpec.describe Contributors::AuditContributionCountsJob, type: :job, disable_ordering_refresh: true do
  it_behaves_like "a pass-through operation job", "contributors.audit_contribution_counts" do
    let!(:job_arg) do
      {
        contributor_id: SecureRandom.uuid
      }
    end
  end

  it_behaves_like "a void operation job", "contributors.audit_contribution_counts"
end
