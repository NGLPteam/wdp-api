# frozen_string_literal: true

module Protocols
  module Pressbooks
    module Books
      class Request < Protocols::Pressbooks::AbstractRequest
        include Protocols::Pressbooks::PaginatedRequest

        responds_with! Protocols::Pressbooks::Books::Response

        suffix "wp-json/pressbooks/v2/books"
      end
    end
  end
end
