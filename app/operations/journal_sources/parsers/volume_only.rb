# frozen_string_literal: true

module JournalSources
  module Parsers
    class VolumeOnly < JournalSources::Parsers::Abstract
      parsed_klass JournalSources::Parsed::VolumeOnly

      def try_parsing!(input)
        try_anystyle! input
      end
    end
  end
end
