# frozen_string_literal: true

RSpec.describe Access::CalculateGrantedPermissionsJob, type: :job do
  let!(:access_grant) { FactoryBot.create :access_grant }

  before do
    GrantedPermission.destroy_all
  end

  it "calculates missing granted permissions" do
    expect do
      described_class.perform_now access_grant
    end.to change(GrantedPermission, :count)
  end
end
