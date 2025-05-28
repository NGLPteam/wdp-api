# frozen_string_literal: true

module Support
  module Networking
    class Download < Support::SimpleServiceOperation
      service_klass ::Support::Networking::Downloader
    end
  end
end
