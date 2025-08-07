# frozen_string_literal: true

RSpec.describe Introspection::LayoutsController, type: :request do
  describe "POST /introspection/layouts/:layout_kind/validate" do
    def build_validation_params_for(path)
      document = fixture_file_upload(file_fixture("layouts/#{path}"))

      {
        document:,
      }
    end

    context "with a valid layout" do
      let!(:params) do
        build_validation_params_for("journal_article_main.xml")
      end

      it "works" do
        expect do
          post(validate_introspection_layout_path(:main), params:)
        end.to execute_safely
      end
    end

    context "with an invalid document provided" do
      let!(:params) do
        document = fixture_file_upload(file_fixture("lorempixel.jpg"))

        {
          document:,
        }
      end

      it "fails as expected" do
        expect do
          post(validate_introspection_layout_path(:main), params:)
        end.to execute_safely

        expect(response).to have_http_status :unprocessable_content
      end
    end

    context "with no layout provided" do
      let!(:params) { {} }

      it "fails" do
        expect do
          post(validate_introspection_layout_path(:main), params:)
        end.to execute_safely

        expect(response).to have_http_status :unprocessable_content
      end
    end
  end
end
