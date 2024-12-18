# frozen_string_literal: true

RSpec.describe Schemas::Instances::WriteProperty, type: :operation do
  let_it_be(:article, refind: true) { FactoryBot.create :item, schema: "nglp:journal_article" }

  let_it_be(:issue_number) { ?5 }
  let_it_be(:citation) { "citation instructions" }

  it "sets a property to the expected value" do
    expect do
      expect_calling_with(article, "issue.number", issue_number).to succeed
    end.to change { article.reload.read_property_value!("issue.number") }.to(issue_number)
      .and change(LayoutInvalidation, :count).by(1)
  end

  it "only affects a single property" do
    article.write_property!("issue.number", issue_number)

    # sanity check
    expect(article.read_property_value!("issue.number")).to eq issue_number

    expect do
      expect_calling_with(article, "citation", citation)
    end.to change { article.reload.read_property_value!("citation") }.to(citation)
      .and keep_the_same { article.reload.read_property_value!("issue.number") }
      .and change(LayoutInvalidation, :count).by(1)
  end
end
