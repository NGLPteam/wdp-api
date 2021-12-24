# frozen_string_literal: true

RSpec.describe Schemas::Associations::Validation::Invalid do
  def invalid_for(declaration, *requirements)
    described_class.new provided_declaration: declaration, requirements: requirements.flatten
  end

  def mutually_invalid(parent, child)
    Schemas::Associations::Validation::MutuallyInvalidConnection.new(
      parent: parent.to_parent,
      child: child.to_child
    )
  end

  let(:valid) { Schemas::Associations::Validation::Valid.new provided_declaration: "testing:valid:1.0.0", requirements: [] }

  let(:invalid_a) { invalid_for "testing:alpha:1.0.0" }
  let(:invalid_b) { invalid_for "testing:beta:1.0.0" }

  let(:invalid_parent) { invalid_for("testing:parent:1.0.0").to_parent }
  let(:invalid_child) { invalid_for("testing:child:1.0.0").to_child }

  shared_examples_for "an invalid result" do
    it "produces a monadic failure" do
      expect(subject.to_monad).to be_a_failure
    end
  end

  context "with a typed parent" do
    subject { invalid_parent }

    it { is_expected.to be_a_parent }
    it { is_expected.not_to be_a_child }
    it { is_expected.not_to be_unspecified }

    describe "#to_parent" do
      it "returns the same object" do
        expect(subject.to_parent).to be subject
      end
    end

    describe "#to_child" do
      it "explodes" do
        expect do
          subject.to_child
        end.to raise_error RuntimeError
      end
    end

    it_behaves_like "an invalid result"
  end

  context "with a typed child" do
    subject { invalid_child }

    it { is_expected.to be_a_child }
    it { is_expected.not_to be_a_parent }
    it { is_expected.not_to be_unspecified }

    describe "#to_parent" do
      it "explodes" do
        expect do
          subject.to_parent
        end.to raise_error RuntimeError
      end
    end

    describe "#to_child" do
      it "returns the same object" do
        expect(subject.to_child).to be subject
      end
    end

    it_behaves_like "an invalid result"
  end

  context "with an unspecified result" do
    subject { invalid_a }

    it { is_expected.not_to be_a_child }
    it { is_expected.not_to be_a_parent }
    it { is_expected.to be_unspecified }

    describe "#to_parent" do
      it "creates a parent" do
        expect(subject.to_parent).to be_a_parent
      end
    end

    describe "#to_child" do
      it "creates a child" do
        expect(subject.to_child).to be_a_child
      end
    end

    it_behaves_like "an invalid result"
  end

  context "when combining" do
    specify "combining two typed results is commutative" do
      expect do
        @parent_then_child = invalid_parent * invalid_child
      end.to execute_safely

      expect do
        @child_then_parent = invalid_child * invalid_parent
      end.to execute_safely

      expect(@parent_then_child).to eq @child_then_parent
    end

    specify "combining a parent with an unspecified commutatively casts the other to child" do
      aggregate_failures do
        expect(invalid_parent * invalid_a).to eq mutually_invalid(invalid_parent, invalid_a)
        expect(invalid_a * invalid_parent).to eq mutually_invalid(invalid_parent, invalid_a)
      end
    end

    specify "combining a child with an unspecified commutatively casts the other to a parent" do
      aggregate_failures do
        expect(invalid_child * invalid_a).to eq mutually_invalid(invalid_a, invalid_child)
        expect(invalid_a * invalid_child).to eq mutually_invalid(invalid_a, invalid_child)
      end
    end

    specify "combining two unspecified results assumes the left operand is the parent" do
      aggregate_failures do
        expect(invalid_a * invalid_b).to eq mutually_invalid invalid_a, invalid_b
        expect(invalid_b * invalid_a).to eq mutually_invalid invalid_b, invalid_a
      end
    end

    specify "combining an invalid with a valid explodes" do
      expect do
        invalid_a * valid
      end.to raise_error TypeError, /cannot combine with #{valid.class}/i
    end

    specify "combining two parents explodes" do
      expect do
        invalid_parent * invalid_a.to_parent
      end.to raise_error TypeError, /cannot combine two results of the same type/i
    end

    specify "combining two children explodes" do
      expect do
        invalid_child * invalid_b.to_child
      end.to raise_error TypeError, /cannot combine two results of the same type/i
    end
  end

  context "when reducing typed results via combination" do
    it "produces a mutually invalid connection with two results" do
      expect([invalid_child, invalid_parent].reduce(&:*)).to be_a_kind_of Schemas::Associations::Validation::MutuallyInvalidConnection
    end

    it "just returns the typed result when there is only one" do
      aggregate_failures do
        expect([invalid_child].reduce(&:*)).to be_a_kind_of Schemas::Associations::Validation::InvalidChild
        expect([invalid_parent].reduce(&:*)).to be_a_kind_of Schemas::Associations::Validation::InvalidParent
      end
    end
  end
end
