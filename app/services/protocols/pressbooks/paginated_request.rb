# frozen_string_literal: true

module Protocols
  module Pressbooks
    module PaginatedRequest
      extend ActiveSupport::Concern

      DEFAULT_PER_PAGE = 10

      included do
        paginated true

        option :current_page, Protocols::Types::CurrentPage, default: proc { 1 }
        option :per_page, Protocols::Types::Integer, default: proc { DEFAULT_PER_PAGE }

        map_query_param! :page, :current_page
        map_query_param! :per_page, :per_page
      end

      def next_page(**options)
        next_options = next_page_options(**options)

        self.class.new(**next_options)
      end

      def next_page_number
        current_page + 1
      end

      def next_page_options(current_page: next_page_number)
        current_options.merge(current_page:)
      end
    end
  end
end
