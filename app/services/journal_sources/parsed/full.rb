# frozen_string_literal: true

module JournalSources
  module Parsed
    # @see JournalSources::ParseFull
    class Full < ::JournalSources::Parsed::Abstract
      mode :full
    end
  end
end
