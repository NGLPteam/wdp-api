# frozen_string_literal: true

module JournalSources
  module Parsed
    # @see JournalSources::ParseVolumeOnly
    class VolumeOnly < ::JournalSources::Parsed::Abstract
      mode :volume_only
    end
  end
end
