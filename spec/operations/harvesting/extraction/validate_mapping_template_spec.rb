# frozen_string_literal: true

RSpec.describe Harvesting::Extraction::ValidateMappingTemplate, type: :operation do
  it "fails as expected on an template with no entities" do
    expect_calling_with(<<~XML).to monad_fail.with([:invalid_mapping_template, [:"extraction_mapping_template.no_entities"]])
    <mapping>
      <entities />
    </mapping>
    XML
  end

  it "fails as expected on an empty template", :aggregate_failures do
    expect_calling_with("").to monad_fail.with([:invalid_mapping_template, [:"extraction_mapping_template.blank"]])
    expect_calling_with(nil).to monad_fail.with([:invalid_mapping_template, [:"extraction_mapping_template.blank"]])
  end

  it "fails as expected with invalid xml" do
    expect_calling_with(<<~XML).to monad_fail.with([:invalid_mapping_template, [:"extraction_mapping_template.not_well_formed"]])
    <mapping
    XML
  end

  it "accepts a valid template" do
    expect_calling_with(Harvesting::Example.first.extraction_mapping_template).to succeed.with(a_kind_of(::Harvesting::Extraction::Mapping))
  end
end
