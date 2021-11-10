# frozen_string_literal: true

RSpec.describe FullText::DeriveDictionary, type: :operation do
  let!(:operation) { described_class.new }

  shared_examples_for "matching codes" do |*codes, lang:|
    codes.flatten.each do |code|
      specify "#{code.inspect} => #{lang.inspect}" do
        expect_calling_with(code).to eq lang
      end
    end
  end

  include_examples "matching codes", "ar", "ara", lang: "arabic"
  include_examples "matching codes", "da", "dan", lang: "danish"
  include_examples "matching codes", "nl", "dut", "nld", lang: "dutch"
  include_examples "matching codes", "en", "eng", lang: "english"
  include_examples "matching codes", "fi", "fin", lang: "finnish"
  include_examples "matching codes", "de", "deu", "ger", lang: "german"
  include_examples "matching codes", "el", "ell", "gre", lang: "greek"
  include_examples "matching codes", "hu", "hun", lang: "hungarian"
  include_examples "matching codes", "id", "ind", lang: "indonesian"
  include_examples "matching codes", "ga", "gle", lang: "irish"
  include_examples "matching codes", "it", "ita", lang: "italian"
  include_examples "matching codes", "lt", "lit", lang: "lithuanian"
  include_examples "matching codes", "ne", "nep", lang: "nepali"
  include_examples "matching codes", "no", "nor", lang: "norwegian"
  include_examples "matching codes", "pt", "por", lang: "portuguese"
  include_examples "matching codes", "ro", "ron", "rum", lang: "romanian"
  include_examples "matching codes", "ru", "rus", lang: "russian"
  include_examples "matching codes", "es", "spa", lang: "spanish"
  include_examples "matching codes", "sv", "swe", lang: "swedish"
  include_examples "matching codes", "ta", "tam", lang: "tamil"
  include_examples "matching codes", "tr", "tur", lang: "turkish"
  include_examples "matching codes", nil, "", "anything", :any_value, lang: "simple"
end
