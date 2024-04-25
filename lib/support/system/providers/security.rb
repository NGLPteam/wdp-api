# frozen_string_literal: true

Support::System.register_provider(:security) do
  prepare do
    # require "third_party/db"
  end

  start do
    register :hashids, memoize: true do
      Hashids.new SecurityConfig.hash_salt
    end

    register :node_verifier, memoize: true do
      ActiveSupport::MessageVerifier.new SecurityConfig.node_salt, digest: "SHA256"
    end
  end
end
