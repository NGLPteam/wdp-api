# frozen_string_literal: true

RSpec.describe Harvesting::Dispatch::BuildMetadataFormat, type: :operation do
  def format_proxy(name)
    WDPAPI::Container["harvesting.metadata.formats.#{name}"]
  end

  def succeed_with_format(name)
    succeed.with format_proxy(name)
  end

  def formattable(name)
    double(:formattable, metadata_format: name.to_s)
  end

  def expect_lookup!(name)
    expect_calling_with(formattable(name)).to succeed_with_format(name)
  end

  it "finds the correct metadata format by duck type" do
    aggregate_failures do
      expect_lookup! :jats
      expect_lookup! :mets
      expect_lookup! :mods
      expect_lookup! :oaidc
    end
  end

  it "fails with an unknown format" do
    expect_calling_with(formattable(:unknown)).to be_a_monadic_failure.with_key(:unknown_metadata_format)
  end

  it "fails with an unformattable object" do
    expect_calling_with(double(:unformattable)).to be_a_monadic_failure.with_key(:invalid_formatter)
  end
end
