# frozen_string_literal: true

RSpec.describe Mutations::DestroyAnnouncement, type: :request, graphql: :mutation do
  mutation_query! <<~GRAPHQL
  mutation destroyAnnouncement($input: DestroyAnnouncementInput!) {
    destroyAnnouncement(input: $input) {
      destroyed
      destroyedId

      ... ErrorFragment
    }
  }
  GRAPHQL

  let_it_be(:announcement, refind: true) { FactoryBot.create :announcement }

  let_mutation_input!(:announcement_id) { announcement.to_encoded_id }

  as_an_admin_user do
    let(:expected_shape) do
      gql.mutation(:destroy_announcement) do |m|
        m[:destroyed] = true
        m[:destroyed_id] = eq(announcement_id).and(be_an_encoded_id.of_a_deleted_model)
      end
    end

    it "destroys the announcement" do
      expect_the_default_request.to change(Announcement, :count).by(-1)

      expect_graphql_data expected_shape
    end
  end
end
