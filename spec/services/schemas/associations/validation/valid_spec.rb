# frozen_string_literal: true

RSpec.describe Schemas::Associations::Validation::Valid do
  def invalid_for(declaration, *requirements)
    Schemas::Associations::Validation::Invalid.new provided_declaration: declaration, requirements: requirements.flatten
  end

  def valid_for(declaration, *requirements)
    described_class.new provided_declaration: declaration, requirements: requirements.flatten
  end

  def valid_connection(parent, child)
    Schemas::Associations::Validation::ValidConnection.new(
      parent: parent.to_parent,
      child: child.to_child
    )
  end

  let(:invalid) { invalid_for "testing:invalid:1.0.0" }
  let(:valid_a) { valid_for "testing:alpha:1.0.0" }
  let(:valid_b) { valid_for "testing:beta:1.0.0" }

  context "type coercion" do
    subject { valid_a }

    describe "#to_parent" do
      it "returns the same object" do
        expect(subject.to_parent).to be subject
      end
    end

    describe "#to_child" do
      it "returns the same object" do
        expect(subject.to_child).to be subject
      end
    end

    describe "#to_monad" do
      it "produces a monadic success" do
        expect(subject.to_monad).to be_a_success
      end
    end
  end

  context "when combining" do
    specify "combining two valid results assumes the left operand is the parent" do
      aggregate_failures do
        expect(valid_a * valid_b).to eq valid_connection valid_a, valid_b
        expect(valid_b * valid_a).to eq valid_connection valid_b, valid_a
      end
    end

    specify "combining an valid with an invalid explodes" do
      expect do
        valid_a * invalid
      end.to raise_error TypeError, /cannot combine with #{invalid.class}/i
    end
  end
end
