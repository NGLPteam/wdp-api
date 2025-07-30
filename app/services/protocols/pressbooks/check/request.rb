# frozen_string_literal: true

module Protocols
  module Pressbooks
    module Check
      class Request < Protocols::Pressbooks::AbstractRequest
        responds_with! Protocols::Pressbooks::Check::Response

        suffix "wp-json/pressbooks/v2"
      end
    end
  end
end
