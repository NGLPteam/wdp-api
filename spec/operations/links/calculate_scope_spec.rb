# frozen_string_literal: true

RSpec.describe Links::CalculateScope, type: :operation do
  let!(:operation) { described_class.new }

  specify { expect("collections.linked.collections").to be_the_result_with(Collection, Collection) }
  specify { expect("collections.linked.collections").to be_the_result_with("Collection", :collection) }
  specify { expect("collections.linked.items").to be_the_result_with(Collection, :item) }

  it "fails with an invalid source" do
    expect_calling_with(nil, Collection).to monad_fail.with_key(:invalid_source)
  end

  it "fails with an invalid target" do
    expect_calling_with(Collection, nil).to monad_fail.with_key(:invalid_target)
  end

  it "fails with an invalid entity" do
    expect_calling_with(Collection, User).to monad_fail.with_key(:invalid_scope)
  end
end
