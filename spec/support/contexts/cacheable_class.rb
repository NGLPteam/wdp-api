# frozen_string_literal: true

RSpec.shared_context "cacheable class" do
  around do |example|
    described_class.cache.clear

    example.run

    described_class.cache.clear
  end
end
