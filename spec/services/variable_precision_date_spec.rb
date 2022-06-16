# frozen_string_literal: true

RSpec.describe VariablePrecisionDate do
  let!(:today) { Date.current }

  let!(:variable_precision_date) { described_class.new }

  subject { variable_precision_date }

  context "with an exact day" do
    let!(:variable_precision_date) { described_class.parse today.to_s }

    it { is_expected.to be_a_day }
    it { is_expected.to be_exact }
    it { is_expected.not_to be_inexact }

    it "compiles to a SQL representation in JSON" do
      expect(variable_precision_date.as_json).to eq %[("#{today}","day")]
    end

    describe "#to_date" do
      it "returns the expected value" do
        expect(variable_precision_date.to_date).to eq today
      end
    end
  end

  context "with a month" do
    let!(:variable_precision_date) { described_class.from_month today.year, today.month }
    let!(:expected_value) { today.at_beginning_of_month }

    specify "the value is normalized" do
      expect(variable_precision_date.value).to eq expected_value
    end

    it { is_expected.to be_inexact }
    it { is_expected.to be_a_month }

    describe "#to_date" do
      it "returns the expected value" do
        expect(variable_precision_date.to_date).to eq expected_value
      end
    end
  end

  context "with a year" do
    let!(:variable_precision_date) { described_class.from_year today.year }
    let!(:expected_value) { today.at_beginning_of_year }

    specify "the value is normalized" do
      expect(variable_precision_date.value).to eq expected_value
    end

    it { is_expected.to be_inexact }
    it { is_expected.to be_a_year }

    describe "#to_date" do
      it "returns the expected value" do
        expect(variable_precision_date.to_date).to eq expected_value
      end
    end
  end

  context "with an invalid date" do
    let!(:variable_precision_date) { described_class.new today, :none }
    let!(:expected_value) { nil }

    it { is_expected.to be_none }
    it { is_expected.to be_inexact }

    specify "the value is normalized" do
      expect(variable_precision_date.value).to eq expected_value
    end

    it "compiles to a SQL representation in JSON" do
      expect(variable_precision_date.as_json).to eq %[(,"none")]
    end

    describe "#to_date" do
      it "returns nothing" do
        expect(variable_precision_date.to_date).to be_nil
      end
    end
  end

  describe ".parse" do
    it "handles a JSON-encoded date" do
      expect(described_class.parse(today.to_s)).to be_exact
    end

    it "handles a hash representation of the date" do
      expect(described_class.parse(value: today, precision: :day)).to be_exact
    end

    it "passes an instance of itself directly" do
      instance = described_class.new today, :day

      expect(described_class.parse(instance)).to be instance
    end

    it "parses a SQL representation" do
      expect(described_class.parse(%[(#{today.to_s.inspect},"month")])).to eq described_class.new(today, :month)
    end

    it "ignores anything else" do
      expect(described_class.parse("literally anything else")).to eq described_class.none
    end
  end

  describe ".parse_sql" do
    it "handles an empty object" do
      expect(described_class.parse_sql(nil)).to eq described_class.none
    end

    it "handles null values" do
      expect(described_class.parse_sql("(,none)")).to eq described_class.none
    end

    it "handles invalid date values" do
      expect(described_class.parse_sql("(1981-01-99,day)")).to eq described_class.none
    end
  end
end
