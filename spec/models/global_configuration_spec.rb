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
end
