# frozen_string_literal: true

module Seeding
  module Contracts
    # Properties for an `nglp:journal`.
    class JournalProperties < Base
      json do
        optional(:cc_license).maybe(:string)
        optional(:description).maybe(:full_text)
        optional(:open_access).maybe(:bool)
        optional(:peer_reviewed).maybe(:bool)
      end
    end
  end
end
