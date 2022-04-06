# frozen_string_literal: true

RSpec.describe GlobalConfiguration, type: :model do
  let!(:global_configuration) { described_class.fetch }

  describe "site" do
    let(:padded_provider_name) { "  A   Very Padded Provider  Name   " }
    let(:squished_provider_name) { padded_provider_name.strip.squish }

    it "strips whitespace on provider_name" do
      expect do
        global_configuration.site.provider_name = padded_provider_name

        global_configuration.save!
      end.to change { global_configuration.site.provider_name }.to(squished_provider_name)
    end
  end

  describe ".reset!" do
    let(:old_provider_name) { "A test name" }
    let(:new_provider_name) { "" }

    before do
      global_configuration.site.provider_name = old_provider_name

      global_configuration.save!
    end

    it "resets certain fields" do
      expect do
        described_class.reset!
      end.to change { global_configuration.reload.site.provider_name }.from(old_provider_name).to(new_provider_name)
    end
  end
end
