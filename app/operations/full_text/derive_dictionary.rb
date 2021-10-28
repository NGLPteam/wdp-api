# frozen_string_literal: true

module FullText
  # Convert an ISO-639 lang code (alpha2 or alpha3) into a supported PG full-text dictionary.
  #
  # @see #call
  class DeriveDictionary
    # @param [String] lang an ISO-639 language code
    # @return [String] the dictionary to use: falls back to `"simple"` if none match.
    def call(lang)
      case lang
      when "ar", "ara" then "arabic"
      when "da", "dan" then "danish"
      when "nl", "dut", "nld" then "dutch"
      when "en", "eng" then "english"
      when "fi", "fin" then "finnish"
      when "de", "deu", "ger" then "german"
      when "el", "ell", "gre" then "greek"
      when "hu", "hun" then "hungarian"
      when "id", "ind" then "indonesian"
      when "ga", "gle" then "irish"
      when "it", "ita" then "italian"
      when "lt", "lit" then "lithuanian"
      when "ne", "nep" then "nepali"
      when "no", "nor" then "norwegian"
      when "pt", "por" then "portuguese"
      when "ro", "ron", "rum" then "romanian"
      when "ru", "rus" then "russian"
      when "es", "spa" then "spanish"
      when "sv", "swe" then "swedish"
      when "ta", "tam" then "tamil"
      when "tr", "tur" then "turkish"
      else
        "simple"
      end
    end
  end
end
