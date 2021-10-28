# frozen_string_literal: true

RSpec.describe SchematicText, type: :model do
  let!(:schematic_text) { FactoryBot.create :schematic_text }

  describe "detecting the dictionary" do
    it "detects the dictionary to use based on the provided lang" do
      expect do
        schematic_text.lang = "en"

        schematic_text.save!
      end.to change(schematic_text, :dictionary).from("simple").to("english")
    end

    context "with a language-specific dictionary" do
      let!(:schematic_text) { FactoryBot.create :schematic_text, :english }

      it "falls back to simple when an unknown lang specified" do
        expect do
          schematic_text.lang = "unknown"

          schematic_text.save!
        end.to change(schematic_text, :dictionary).from("english").to("simple")
      end

      it "falls back to simple when no lang specified" do
        expect do
          schematic_text.lang = nil

          schematic_text.save!
        end.to change(schematic_text, :dictionary).from("english").to("simple")
      end
    end
  end
end
