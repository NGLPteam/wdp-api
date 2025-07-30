# frozen_string_literal: true

module Protocols
  module Pressbooks
    module Check
      class Response < AbstractResponse
        after_initialize :parse_data!

        # @return [Protocols::Pressbooks::Check::Record]
        attr_reader :data

        private

        # @return [void]
        def parse_data!
          @data = Metadata::Pressbooks::Check::Data.from_json(parsed_body.to_json)
        end
      end
    end
  end
end
