# frozen_string_literal: true

RSpec.describe "nglp:journal_article", type: :request do
  let!(:item) { FactoryBot.create :item, schema: "nglp:journal_article" }

  context "when updating a journal article" do
    include_context "applies schema properties"

    let(:token) { token_helper.build_token has_global_admin: true }

    let(:entity_id) { item.to_encoded_id }

    let(:body_kind) { "HTML" }
    let(:body_content) { "<p>Some Body Content</p>" }
    let(:body_lang) { "en" }
    let(:volume_id) { ?1 }
    let(:issue_id) { ?1 }
    let(:issue_sortable_number) { 1 }
    let(:issue_number) { issue_id }
    let(:issue_title) { "Some Issue" }
    let(:collected) { { value: "2021/01/05", precision: "MONTH" } }
    let(:citation) do
      <<~MARKDOWN
      First Last, Journal (New York: Test Press, 2016), 315–16.
      MARKDOWN
    end

    let(:property_values) do
      gql.object do |pv|
        pv.prop :body do |b|
          b.prop :kind, body_kind
          b.prop :lang, body_lang
          b.prop :content, body_content
        end

        pv.prop :citation, citation

        pv.prop "volume.id", volume_id
        pv.prop "issue.id", issue_id
        pv.prop "issue.title", issue_title
        pv.prop "issue.number", issue_number
        pv.prop "issue.sortable_number", issue_sortable_number
        pv.prop "meta.collected", collected
      end
    end

    let(:expected_shape) do
      gql.mutation :apply_schema_properties, schema: true do |m|
        m.prop :entity do |ent|
          ent.prop :id, entity_id
          ent.prop "schema_instance_context.validity.valid", true
          ent.schema_properties do |sp|
            sp.full_text :body do |ft|
              ft[:kind] = body_kind
              ft[:lang] = body_lang
              ft[:content] = body_content
            end

            sp.full_text :abstract

            sp.markdown :citation, citation

            sp.boolean :preprint_version

            sp.url :online_version

            sp.asset :pdf_version

            sp.group :volume do |vp|
              vp.string :id do |vid|
                vid.prop :content, volume_id
              end
            end

            sp.group :issue do |ip|
              ip.string :title, issue_title
              ip.string :number, issue_number
              ip.integer :sortable_number, issue_sortable_number
              ip.string :id, issue_id
              ip.integer :fpage
              ip.integer :lpage
            end

            sp.group :meta do |mp|
              mp.variable_date :collected, value: VariablePrecisionDate.parse(collected).value.to_s, precision: "MONTH"
              mp.variable_date :published
              mp.integer :page_count
            end
          end
        end
      end
    end

    it "accepts valid values" do
      make_default_request!

      expect_graphql_data expected_shape
    end

    context "when a required property is blank" do
      let(:issue_id) { nil }
      let(:issue_number) { ?1 }

      let(:expected_shape) do
        gql.mutation :apply_schema_properties, schema: true, no_schema_errors: false do |m|
          m.schema_errors do |se|
            se.error "issue.id", :filled?
          end

          m[:entity] = be_blank
        end
      end

      it "fails with the expected schema error" do
        make_default_request!

        expect_graphql_data expected_shape
      end
    end
  end
end
