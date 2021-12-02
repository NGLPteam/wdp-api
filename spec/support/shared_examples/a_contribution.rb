# frozen_string_literal: true

RSpec.shared_examples_for "a contribution" do
  context "when destroying the contribution" do
    it "updates the contribution_count" do
      expect do
        contribution.destroy!
      end.to change { contributor.reload.contribution_count }.by(-1)
    end
  end
end
