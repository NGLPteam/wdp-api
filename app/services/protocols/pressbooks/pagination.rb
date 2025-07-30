# frozen_string_literal: true

module Protocols
  module Pressbooks
    class Pagination < Support::WritableStruct
      attribute? :current_page, Protocols::Types::CurrentPage

      attribute? :total_pages, Protocols::Types::PageCount

      attribute? :total_records, Protocols::Types::RecordCount

      def more?
        current_page < total_pages
      end

      alias has_more? more?
    end
  end
end
