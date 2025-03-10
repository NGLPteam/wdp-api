# frozen_string_literal: true

module Harvesting
  module Metadata
    module JATS
      class KwdGroupDrop < Harvesting::Metadata::JATS::AbstractJATSDrop
        # after_initialize :extract_kwds!

        data_subdrops! Harvesting::Metadata::JATS::KwdDrop, :kwd

        # attr_reader :kwds

        # alias kwd kwds

        # private

        ## @return [void]
        # def extract_kwds!
        # @kwds = data_subdrops Harvesting::Metadata::JATS::KwdDrop, @data.kwd
        # end
      end
    end
  end
end
