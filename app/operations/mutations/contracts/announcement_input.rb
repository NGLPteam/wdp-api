# frozen_string_literal: true

module Mutations
  module Contracts
    # A contract for creating or updating an {Announcement}.
    class AnnouncementInput < ApplicationContract
      json do
        required(:published_on).value(:date)
        required(:header).filled("coercible.string")
        required(:teaser).filled("coercible.string")
        required(:body).filled("coercible.string")
      end
    end
  end
end
