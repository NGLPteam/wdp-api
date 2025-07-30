# frozen_string_literal: true

module Metadata
  module Pressbooks
    module Naming
      module HasPersonalName
        extend ActiveSupport::Concern

        def has_parsed_name
          parsed_name.valid?
        end

        alias has_parsed_name? has_parsed_name

        def parsed_name
          @parsed_name ||= Metadata::Pressbooks::Naming::PersonalName.parse(parsed_name_source)
        end

        # @abstract
        # @api private
        # @return [String, nil]
        def parsed_name_source; end
      end
    end
  end
end
