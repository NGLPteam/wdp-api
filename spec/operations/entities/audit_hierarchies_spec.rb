# frozen_string_literal: true

RSpec.describe Entities::AuditHierarchies, type: :operation do
  include ActiveJob::TestHelper

  let!(:community) { FactoryBot.create :community }

  it "will detect if an entity is deleted without cleaning up the table" do
    expect do
      perform_enqueued_jobs do
        FactoryBot.create :collection, community:
      end
    end.to change(EntityHierarchy, :count).by(2)

    expect do
      ApplicationRecord.connection.execute <<~SQL
      DELETE FROM collections WHERE community_id = #{community.quoted_id};
      SQL
    end.to change(Collection, :count).by(-1).and keep_the_same(EntityHierarchy, :count)

    expect do
      expect_calling.to succeed.with(2)
    end.to change(EntityHierarchy, :count).by(-2)
  end
end
