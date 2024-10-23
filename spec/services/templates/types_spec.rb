# frozen_string_literal: true

RSpec.describe Templates::Types do
  describe "Templates::Types::LayoutRecord" do
    let(:type) { ::Templates::Types::LayoutRecord }

    it "works with instances of Layout" do
      expect(type[::Layout.first]).to be_a_kind_of(::Layout)
    end

    it "works with kinds of Layout", :aggregate_failures do
      ::Templates::Types::LayoutKind.values.each do |kind|
        expect(type[kind]).to eq ::Layout.find(kind)
      end
    end

    it "raises an error with invalid input" do
      expect do
        type[123]
      end.to raise_error(Dry::Types::CoercionError, /layout/)
    end

    it "raises an error with empty input" do
      expect do
        type[nil]
      end.to raise_error(Dry::Types::CoercionError, /layout/)
    end
  end

  describe "Templates::Types::TemplateRecord" do
    let(:type) { Templates::Types::TemplateRecord }

    it "works with instances of Template" do
      expect(type[::Template.first]).to be_a_kind_of(::Template)
    end

    it "works with kinds of Template", :aggregate_failures do
      ::Templates::Types::TemplateKind.values.each do |kind|
        expect(type[kind]).to eq ::Template.find(kind)
      end
    end

    it "raises an error with invalid input" do
      expect do
        type[123]
      end.to raise_error(Dry::Types::CoercionError, /template/)
    end

    it "raises an error with empty input" do
      expect do
        type[nil]
      end.to raise_error(Dry::Types::CoercionError, /template/)
    end
  end
end
