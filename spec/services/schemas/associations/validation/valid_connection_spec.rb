# frozen_string_literal: true

RSpec.describe Schemas::Associations::Validation::ValidConnection do
  def valid_for(declaration, *requirements)
    Schemas::Associations::Validation::Valid.new provided_declaration: declaration, requirements: requirements.flatten
  end

  let(:valid_a) { valid_for "testing:alpha:1.0.0" }
  let(:valid_b) { valid_for "testing:beta:1.0.0" }
  let(:connection) { valid_a * valid_b }

  context "type coercion" do
    subject { connection }

    describe "#to_monad" do
      it "produces a monadic success" do
        expect(subject.to_monad).to be_a_success
      end
    end
  end
end
