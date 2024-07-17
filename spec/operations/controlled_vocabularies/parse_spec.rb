# frozen_string_literal: true

RSpec.describe ControlledVocabularies::Parse, type: :operation do
  let(:valid_definition) do
    cv_definition_for("marc_codes")
  end

  it "parses a valid definition" do
    expect_calling_with(valid_definition).to succeed.with(a_kind_of(ControlledVocabularies::Transient::Root))
  end

  it "catches items that are too deep" do
    expect_calling_with(cv_def_too_deep).to monad_fail
  end

  it "catches items that are not unique" do
    expect_calling_with(cv_def_not_unique).to monad_fail
  end

  it "catches definitions with no items" do
    expect_calling_with(cv_def_empty).to monad_fail
  end
end
