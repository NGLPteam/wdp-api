# frozen_string_literal: true

Redis::Objects.redis = ConnectionPool.new(size: 5, timeout: 5) do
  Redis.new(
    url: ENV["REDIS_URL"],
    db: 1,
    driver: :ruby,
    ssl_params: { verify_mode: OpenSSL::SSL::VERIFY_NONE }
  )
end
