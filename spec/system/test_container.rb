# frozen_string_literal: true

module WDPAPI
  class TestContainer < Dry::System::Container
    configure do |config|
      config.root = Pathname(__dir__)

      config.auto_register << "lib"

      config.default_namespace = "testing"
    end

    load_paths!("lib")
  end
end
