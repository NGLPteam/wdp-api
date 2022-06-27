# frozen_string_literal: true

RSpec.describe Searching::Compilation::EncodeJoinName, type: :operation do
  it "works as expected" do
    expect_calling_with("some.path").to be_present
  end
end
