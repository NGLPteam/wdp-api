# frozen_string_literal: true

RSpec.describe Schemas::Associations::Validation::MutuallyInvalidConnection do
  def invalid_for(declaration, *requirements)
    Schemas::Associations::Validation::Invalid.new provided_declaration: declaration, requirements: requirements.flatten
  end

  let(:invalid_a) { invalid_for "testing:alpha:1.0.0" }
  let(:invalid_b) { invalid_for "testing:beta:1.0.0" }

  let(:connection) { invalid_a * invalid_b }

  context "type coercion" do
    subject { connection }

    describe "#to_monad" do
      it "produces a monadic success" do
        expect(subject.to_monad).to be_a_failure
      end
    end
  end
end
