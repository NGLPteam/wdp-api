# frozen_string_literal: true

module Metadata
  module METS
    module Enums
      class ArcLinkOrder < ::Metadata::Shared::AbstractEnum
        values! "ordered", "unordered"
      end
    end
  end
end
