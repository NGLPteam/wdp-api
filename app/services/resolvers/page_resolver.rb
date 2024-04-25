# frozen_string_literal: true

module Resolvers
  class PageResolver < AbstractResolver
    include Resolvers::Enhancements::PageBasedPagination

    type Types::PageType.connection_type, null: false

    scope { object.present? ? object.pages : Page.none }
  end
end
