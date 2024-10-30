# frozen_string_literal: true

RSpec.describe Template, type: :model do
  described_class.find_each do |template|
    describe template.inspect do
      it "is valid" do
        expect do
          template.validate!
        end.to execute_safely
      end
    end
  end
end
