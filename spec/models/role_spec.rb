# frozen_string_literal: true

RSpec.describe Role, type: :model do
  let(:acl) do
    Roles::AccessControlList.build_with(false).as_json.with_indifferent_access
  end

  let!(:role) { FactoryBot.create :role, access_control_list: acl }

  describe "#allowed_actions" do
    subject { role.allowed_actions }

    context "with read permissions for items" do
      let(:acl) do
        super().tap do |h|
          h[:items][:read] = true
        end
      end

      it "contains the expected permissions" do
        is_expected.to match_array %w[items.read]
      end
    end
  end
end
