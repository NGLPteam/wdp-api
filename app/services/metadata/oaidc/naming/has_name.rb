# frozen_string_literal: true

module Metadata
  module OAIDC
    module Naming
      module HasName
        extend ActiveSupport::Concern

        def has_name
          name.valid?
        end

        alias has_name? has_name

        def name
          @name ||= Metadata::OAIDC::Naming::Name.parse(content)
        end
      end
    end
  end
end
