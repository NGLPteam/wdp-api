# frozen_string_literal: true

RSpec.shared_context "misbehaving SSL upstream" do
  let_it_be(:misbehaving_ssl_response) { "SSL_connect returned=1 errno=0 peeraddr=127.0.0.1:443 state=error: unexpected eof while reading" }
  let_it_be(:misbehaving_ssl_exception) { OpenSSL::SSL::SSLError.new(misbehaving_ssl_response) }
end
