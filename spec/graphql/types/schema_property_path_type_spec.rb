# frozen_string_literal: true

RSpec.describe ::Types::SchemaPropertyPathType do
  describe ".coerce_input" do
    it "accepts nested property paths" do
      expect(described_class.coerce_input("nested.path", nil)).to eq "nested.path"
    end

    it "accepts top-level property paths" do
      expect(described_class.coerce_input("top_level_path", nil)).to eq "top_level_path"
    end

    it "raises an execution error on invalid data" do
      expect do
        described_class.coerce_input("not! a property", nil)
      end.to raise_error GraphQL::ExecutionError, /violates constraints/
    end
  end

  describe "coerce_result" do
    it "accepts nested property paths" do
      expect(described_class.coerce_result("nested.path", nil)).to eq "nested.path"
    end

    it "accepts top-level property paths" do
      expect(described_class.coerce_result("top_level_path", nil)).to eq "top_level_path"
    end

    it "raises the original error on invalid data" do
      expect do
        described_class.coerce_result("not! a property", nil)
      end.to raise_error Dry::Types::ConstraintError, /violates constraints/
    end
  end
end
