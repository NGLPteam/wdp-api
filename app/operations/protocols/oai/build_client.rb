# frozen_string_literal: true

module Protocols
  module OAI
    # @see Protocols::OAI::ClientBuilder
    class BuildClient < Support::SimpleServiceOperation
      service_klass Protocols::OAI::ClientBuilder
    end
  end
end
