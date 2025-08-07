# frozen_string_literal: true

RSpec.describe Utility::PrettifyXML, type: :operation do
  let_it_be(:data_root) { Rails.root.join("spec", "data") }
  let_it_be(:messy_xml) { data_root.join("messy.xml").read }
  let_it_be(:clean_xml) { data_root.join("clean.xml").read }

  it "reformats CDATA the way we want" do
    expect_calling_with(messy_xml).to eq clean_xml
  end
end
