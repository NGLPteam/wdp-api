# frozen_string_literal: true

RSpec.describe Mutations::UpdateGlobalConfiguration, type: :request do
  context "as an admin" do
    let(:token) { token_helper.build_token has_global_admin: true }

    let!(:color) { "blue" }
    let!(:font) { "style2" }
    let!(:provider_name) { "Some Provider Name" }

    let!(:site) { { provider_name: provider_name } }

    let!(:theme) { { color: color, font: font } }

    let!(:mutation_input) do
      {
        site: site,
        theme: theme,
      }
    end

    let!(:graphql_variables) do
      { input: mutation_input }
    end

    let(:expected_site) { site }
    let(:expected_theme) { theme }
    let(:expected_global_configuration) do
      {
        site: expected_site,
        theme: expected_theme,
      }
    end

    let(:expected_errors) { be_blank }

    let(:expected_shape) do
      {
        update_global_configuration: {
          global_configuration: expected_global_configuration,
          attribute_errors: expected_errors,
        },
      }
    end

    let!(:query) do
      <<~GRAPHQL
      mutation updateGlobalConfiguration($input: UpdateGlobalConfigurationInput!) {
        updateGlobalConfiguration(input: $input) {
          globalConfiguration {
            site {
              providerName
            }

            theme {
              color
              font
            }
          }

          attributeErrors {
            path
            messages
          }
        }
      }
      GRAPHQL
    end

    it "updates the config" do
      expect do
        make_default_request!
      end.to change { GlobalConfiguration.fetch.site.as_json }.and change { GlobalConfiguration.fetch.theme.as_json }

      expect_graphql_response_data expected_shape, decamelize: true
    end

    context "when omitting site but providing theme" do
      let(:mutation_input) do
        { theme: theme }
      end

      let(:expected_site) { GlobalConfiguration.fetch.site.as_json }

      it "partially updates the config" do
        expect do
          make_default_request!
        end.to keep_the_same { GlobalConfiguration.fetch.site.as_json }.and change { GlobalConfiguration.fetch.theme.as_json }

        expect_graphql_response_data expected_shape, decamelize: true
      end
    end

    context "when providing nil as a theme" do
      let(:theme) { nil }
      let(:expected_theme) { GlobalConfiguration.fetch.theme.as_json }

      it "partially updates the config" do
        expect do
          make_default_request!
        end.to change { GlobalConfiguration.fetch.site.as_json }.and keep_the_same { GlobalConfiguration.fetch.theme.as_json }

        expect_graphql_response_data expected_shape, decamelize: true
      end
    end

    shared_context "an invalid request" do
      let(:expected_global_configuration) { nil }

      it "fails to update" do
        expect do
          make_default_request!
        end.to keep_the_same { GlobalConfiguration.fetch.site.as_json }.and keep_the_same { GlobalConfiguration.fetch.theme.as_json }

        expect_graphql_response_data expected_shape, decamelize: true
      end
    end

    context "when providing an empty service provider name" do
      include_context "an invalid request"

      let(:provider_name) { "" }

      let(:expected_errors) do
        gql.attribute_errors do |eb|
          eb.error "site.providerName", :filled?
        end
      end
    end

    context "when providing an invalid color" do
      include_context "an invalid request"

      let(:color) { "something invalid" }

      let(:expected_errors) do
        gql.attribute_errors do |eb|
          eb.error "theme.color" do |e|
            e.included_in Settings::Types::COLOR_SCHEMES
          end
        end
      end
    end

    context "when providing an invalid font" do
      include_context "an invalid request"

      let(:font) { "something invalid" }

      let(:expected_errors) do
        gql.attribute_errors do |eb|
          eb.error "theme.font" do |e|
            e.included_in Settings::Types::FONT_SCHEMES
          end
        end
      end
    end
  end
end
