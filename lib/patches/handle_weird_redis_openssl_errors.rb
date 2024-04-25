# frozen_string_literal: true

module Patches
  module HandleWeirdRedisOpenSSLErrors
    def call(...)
      Retryable.retryable(matching: /SSL_read: sslv3 alert bad record mac/, tries: 3) do
        super
      end
    end
  end
end

Redis::Client.prepend Patches::HandleWeirdRedisOpenSSLErrors
