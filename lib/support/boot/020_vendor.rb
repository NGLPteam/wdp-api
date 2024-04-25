# frozen_string_literal: true

module Support
  module Vendor
    BASE_PATH = Pathname("../vendor").expand_path(__dir__)

    ISO_639_3_CODES = YAML.load_file(BASE_PATH.join("iso_639_3_codes.yaml"))
  end
end
