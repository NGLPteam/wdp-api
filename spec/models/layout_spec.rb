# frozen_string_literal: true

RSpec.describe Layout, type: :model do
  described_class.find_each do |layout|
    describe layout.inspect do
      it "is valid" do
        expect do
          layout.validate!
        end.to execute_safely
      end
    end
  end
end
