# frozen_string_literal: true

RSpec.describe Schemas::Instances::WriteProperty, type: :operation do
  let_it_be(:article, refind: true) { FactoryBot.create :item, schema: "nglp:journal_article" }

  let_it_be(:meta_collected) { VariablePrecisionDate.parse(Date.current) }
  let_it_be(:citation) { "citation instructions" }

  it "sets a property to the expected value" do
    expect do
      expect_calling_with(article, "meta.collected", meta_collected).to succeed
    end.to change { article.reload.read_property_value!("meta.collected") }.to(meta_collected)
      .and change(LayoutInvalidation, :count).by(1)
  end

  it "only affects a single property" do
    article.write_property!("meta.collected", meta_collected)

    # sanity check
    expect(article.read_property_value!("meta.collected")).to eq meta_collected

    expect do
      expect_calling_with(article, "citation", citation)
    end.to change { article.reload.read_property_value!("citation") }.to(citation)
      .and keep_the_same { article.reload.read_property_value!("meta.collected") }
      .and change(LayoutInvalidation, :count).by(1)
  end
end
