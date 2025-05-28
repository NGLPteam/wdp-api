# frozen_string_literal: true

using Support::Networking::MisbehavingSSLUpstream::ErrorMatcher

module Support
  module Networking
    module MisbehavingSSLUpstream
      class Error < ::Faraday::SSLError
        class << self
          def match?(exception)
            exception.misbehaving_ssl_upstream?
          end

          def maybe_wrap_and_reraise!(exception)
            raise exception unless match?(exception)

            # :nocov:
            raise exception if exception.kind_of?(self)
            # :nocov:

            raise new(exception, nil)
          end
        end
      end
    end
  end
end
