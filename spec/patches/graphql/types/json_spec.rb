# frozen_string_literal: true

RSpec.describe GraphQL::Types::JSON do
  describe ".coerce_input override" do
    def coercing(value)
      described_class.coerce_input(value, nil)
    end

    shared_examples_for "working input" do
      it "coerces the input as expected" do
        expect(coercing(input_value)).to eq coerced_value
      end
    end

    let(:value) { "input" }

    let(:input_value) { value.to_json }

    let(:coerced_value) { value.as_json }

    context "with a hash" do
      let(:value) { { foo: "bar" } }

      context "when it is JSON-encoded" do
        include_examples "working input"
      end

      context "when it is a plain ruby object" do
        let(:input_value) { value.as_json }
        include_examples "working input"
      end
    end

    context "with a plain, non-JSON string" do
      let(:input_value) { value }

      include_examples "working input"
    end
  end
end
