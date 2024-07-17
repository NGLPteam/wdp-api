# frozen_string_literal: true

RSpec.describe ControlledVocabularies::Validate, type: :operation do
  let(:valid_definition) do
    cv_definition_for("marc_codes")
  end

  it "validates a valid definition" do
    expect_calling_with(valid_definition).to succeed
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
