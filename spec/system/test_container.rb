# frozen_string_literal: true

module WDPAPI
  class TestContainer < Dry::System::Container
    use :zeitwerk

    configure do |config|
      config.root = Pathname(__dir__)

      config.component_dirs.auto_register = true

      config.component_dirs.add "lib" do |dir|
        dir.namespaces.add "testing", key: nil
      end
    end
  end
end
