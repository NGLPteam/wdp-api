# frozen_string_literal: true

RSpec.describe Schemas::Instances::ReadProperty, type: :operation do
  let(:operation) { described_class.new }

  let!(:article) { FactoryBot.create :item, schema: "nglp:journal_article" }

  it "can fetch a top-level scalar property" do
    expect_calling_with(article, "body").to succeed.with(Schemas::Properties::Reader)
  end

  it "can fetch a group property" do
    expect_calling_with(article, "meta").to succeed.with(Schemas::Properties::GroupReader)
  end

  it "can fetch a nested property" do
    expect_calling_with(article, "meta.collected").to succeed.with(Schemas::Properties::Reader)
  end

  it "handles unknown properties" do
    expect_calling_with(article, "issue.something_missing").to monad_fail.with_key(:unknown_property)
  end
end
