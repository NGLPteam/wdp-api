# frozen_string_literal: true

RSpec.describe "Query.viewer", type: :request do
  let!(:query) do
    <<~GRAPHQL
    query getViewer {
      viewer {
        accessManagement
        anonymous
        allowedActions
        id
        name
        email
        emailVerified
        globalAdmin
        slug
        uploadAccess
        uploadToken
        avatar {
          small {
            webp {
              url
              alt
            }
          }
        }
      }
    }
    GRAPHQL
  end

  let(:expected_upload_token) do
    current_user.has_any_upload_access? ? be_present : be_nil
  end

  let(:current_user) { AnonymousUser.new }

  let(:expected_access_management) { ::Types::AccessManagementType.name_for_value(current_user.access_management) }

  let(:expected_shape) do
    gql.object do |obj|
      obj.prop :viewer do |v|
        v[:access_management] = expected_access_management
        v[:allowed_actions] = current_user.allowed_actions
        v[:anonymous] = current_user.anonymous?
        v[:email] = current_user.email
        v[:email_verified] = current_user.email_verified
        v[:global_admin] = current_user.has_global_admin_access?
        v[:id] = current_user.to_encoded_id
        v[:name] = current_user.name
        v[:slug] = current_user.system_slug
        v[:upload_access] = current_user.has_any_upload_access?
        v[:upload_token] = expected_upload_token
      end
    end
  end

  context "as an admin" do
    let!(:current_user) { FactoryBot.create :user, :admin, :with_avatar, email_verified: true }

    let(:token) { token_helper.build_token from_user: current_user }

    it "fetches the right values" do
      expect_request! do |req|
        req.effect! execute_safely

        req.data! expected_shape
      end
    end
  end

  context "as an anonymous user" do
    let(:token) { nil }

    it "fetches the right values" do
      expect_request! do |req|
        req.effect! execute_safely

        req.data! expected_shape
      end
    end
  end
end
