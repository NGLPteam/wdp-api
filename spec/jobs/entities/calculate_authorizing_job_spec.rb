# frozen_string_literal: true

RSpec.describe Entities::CalculateAuthorizingJob, type: :job do
  it_behaves_like "a pass-through operation job", "entities.calculate_authorizing" do
    let!(:job_arg) do
      {
        auth_path: "foo.bar"
      }
    end
  end

  it_behaves_like "a void operation job", "entities.calculate_authorizing"
end
