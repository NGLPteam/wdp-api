# frozen_string_literal: true

RSpec.describe Schemas::Mappers::SchemaDeclaration do
  let_it_be(:sample_with_version) do
    <<~XML.strip_heredoc.strip
    <schema namespace="test" identifier="schema">
      <gteq>2</gteq>
      <lt>5</lt>
      <junk>ignored</junk>
    </schema>
    XML
  end

  let_it_be(:sample_sans_version) do
    <<~XML.strip_heredoc.strip
    <schema namespace="test" identifier="schema"/>
    XML
  end

  # @param [String] xml
  # @return [Schemas::Mappers::SchemaDeclaration]
  def parse_xml!(xml)
    parsed = nil

    expect do
      parsed = described_class.from_xml(xml)
    end.to execute_safely

    return parsed
  end

  it "can parse a versioned declaration" do
    parsed = parse_xml! sample_with_version

    aggregate_failures do
      expect(parsed).to be_satisfied_by(2)
      expect(parsed).not_to be_satisfied_by(5)
      expect(parsed).to have_attributes(namespace: "test", identifier: "schema")

      expect do
        parsed.to_ordering_filter
      end.to execute_safely

      expect do
        parsed.to_xml
      end.to execute_safely
    end
  end

  it "can parse a declaration without any versions" do
    parsed = parse_xml! sample_sans_version

    aggregate_failures do
      expect(parsed.version).to be_present.and be_none
      expect(parsed).to have_attributes(namespace: "test", identifier: "schema")

      expect do
        parsed.to_ordering_filter
      end.to execute_safely

      expect(parsed.to_xml).to eq sample_sans_version
    end
  end
end
