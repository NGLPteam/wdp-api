# frozen_string_literal: true

RSpec.describe Harvesting::Dispatch::BuildProtocol, type: :operation do
  def protocol_proxy(name)
    WDPAPI::Container["harvesting.protocols.#{name}"]
  end

  def succeed_with_protocol(name)
    succeed.with protocol_proxy(name)
  end

  def with_protocol(name)
    FactoryBot.create(:harvest_source).tap do |x|
      allow(x).to receive(:protocol).and_return(name.to_s)
    end
  end

  def with_source(source)
    double(:sourceable, harvest_source: source)
  end

  def expect_lookup!(name)
    expect_calling_with(with_protocol(name)).to succeed_with_protocol(name)
  end

  it "finds the correct protocol from the harvest source" do
    expect_lookup! :oai
  end

  it "can look up from an associated harvest source" do
    expect_calling_with(with_source(with_protocol(:oai))).to succeed_with_protocol(:oai)
  end

  it "fails with an unknown protocol" do
    expect_calling_with(with_protocol(:unknown)).to be_a_monadic_failure.with_key(:unknown_protocol)
  end

  it "fails with an unsupported object" do
    expect_calling_with(double(:unsupported)).to be_a_monadic_failure.with_key(:unknown_origin)
  end
end
