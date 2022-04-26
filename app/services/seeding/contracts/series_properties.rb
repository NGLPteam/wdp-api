# frozen_string_literal: true

module Seeding
  module Contracts
    # Properties for an `nglp:series`.
    class SeriesProperties < Base
      json do
        optional(:about).maybe(:string)
      end
    end
  end
end
