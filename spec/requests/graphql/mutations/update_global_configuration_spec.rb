# frozen_string_literal: true

RSpec.describe Mutations::UpdateGlobalConfiguration, type: :request, graphql: :mutation do
  mutation_query! <<~GRAPHQL
  mutation updateGlobalConfiguration($input: UpdateGlobalConfigurationInput!) {
    updateGlobalConfiguration(input: $input) {
      globalConfiguration {
        institution {
          name
        }

        site {
          installationName
          installationHomePageCopy
          providerName

          footer {
            copyrightStatement
            description
          }
        }

        theme {
          color
          font
        }
      }

      ... ErrorFragment
    }
  }
  GRAPHQL

  context "as an admin" do
    let(:token) { token_helper.build_token has_global_admin: true }

    let!(:color) { "blue" }
    let!(:font) { "style2" }
    let!(:institution_name) { "Some Institution Name" }
    let!(:provider_name) { "Some Provider Name" }
    let!(:installation_name) { "Some Installation Name" }
    let!(:installation_home_page_copy) { "Some installation copy that appears on the home page." }
    let!(:footer_copyright_statement) { "Some Copyright Statement" }
    let!(:footer_description) { "Some Footer Description" }
    let!(:footer) do
      {
        copyright_statement: footer_copyright_statement,
        description: footer_description,
      }
    end

    let_mutation_input!(:institution) { { name: institution_name } }

    let_mutation_input!(:site) do
      {
        installation_name: installation_name,
        installation_home_page_copy: installation_home_page_copy,
        provider_name: provider_name,
        footer: footer,
      }
    end

    let_mutation_input!(:theme) do
      { color: color, font: font }
    end

    let!(:expected_footer) { footer }

    let(:expected_institution) { institution }
    let(:expected_site) { site.merge(footer: expected_footer) }
    let(:expected_theme) { theme }
    let(:expected_global_configuration) do
      {
        institution: expected_institution,
        site: expected_site,
        theme: expected_theme,
      }
    end

    let(:expected_errors) { be_blank }

    let(:has_errors) { false }

    let(:expected_shape) do
      gql.mutation :update_global_configuration, no_errors: !has_errors do |m|
        m[:global_configuration] = expected_global_configuration
        m[:attribute_errors] = expected_errors
      end
    end

    it "updates the config" do
      expect_the_default_request.to change { GlobalConfiguration.fetch.site.as_json }.and change { GlobalConfiguration.fetch.theme.as_json }

      expect_graphql_data expected_shape
    end

    context "when supplying a null value for certain fields" do
      let!(:institution_name) { nil }

      let(:expected_institution) { institution.merge(name: "") }

      it "ensures it is always a string" do
        expect_the_default_request.to keep_the_same { GlobalConfiguration.fetch.institution.name }

        expect_graphql_data expected_shape
      end
    end

    context "when omitting site but providing theme" do
      let(:mutation_input) do
        { theme: theme }
      end

      let(:expected_institution) { GlobalConfiguration.fetch.institution.as_json }

      let(:expected_site) { GlobalConfiguration.fetch.site.as_json }

      it "partially updates the config" do
        expect_the_default_request.to keep_the_same { GlobalConfiguration.fetch.site.as_json }.and change { GlobalConfiguration.fetch.theme.as_json }

        expect_graphql_data expected_shape
      end
    end

    context "when omitting footer" do
      before do
        config = GlobalConfiguration.fetch

        config.site.footer.description = footer_description

        config.save!
      end

      let!(:footer) { nil }

      let(:expected_footer) { { description: footer_description } }

      it "does not clobber existing values" do
        expect_the_default_request.to keep_the_same { GlobalConfiguration.fetch.site.footer.as_json }

        expect_graphql_data expected_shape
      end
    end

    context "when providing nil as a theme" do
      let(:theme) { nil }
      let(:expected_theme) { GlobalConfiguration.fetch.theme.as_json }

      it "partially updates the config" do
        expect_the_default_request.to change { GlobalConfiguration.fetch.site.as_json }.and keep_the_same { GlobalConfiguration.fetch.theme.as_json }

        expect_graphql_data expected_shape
      end
    end

    shared_context "an invalid request" do
      let(:expected_global_configuration) { nil }

      it "fails to update" do
        expect_the_default_request.to keep_the_same { GlobalConfiguration.fetch.site.as_json }.and keep_the_same { GlobalConfiguration.fetch.theme.as_json }

        expect_graphql_data expected_shape
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
