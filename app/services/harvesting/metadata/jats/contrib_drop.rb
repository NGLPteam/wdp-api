# frozen_string_literal: true

module Harvesting
  module Metadata
    module JATS
      class ContribDrop < Harvesting::Metadata::JATS::AbstractJATSDrop
        data_attr! :contrib_type, :string

        data_subdrops! EmailDrop, :email, expose_first: true

        data_subdrops! NameDrop, :name, expose_first: true
      end
    end
  end
end
