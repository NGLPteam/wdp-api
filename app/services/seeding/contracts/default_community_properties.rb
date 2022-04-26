# frozen_string_literal: true

module Seeding
  module Contracts
    # Properties for a `default:community`
    class DefaultCommunityProperties < Base
      json do
        optional(:featured).maybe(:hash) do
          optional(:series).value(:string_list)
          optional(:journals).value(:string_list)
          optional(:issue).value(:safe_string)
          optional(:units).value(:string_list)
        end
      end
    end
  end
end
