# frozen_string_literal: true

module Metadata
  module METS
    module Common
      # @note Requires the including class to implement `#each_file`
      module EnumeratesFiles
        extend ActiveSupport::Concern

        included do
          attribute :files, method: :enumerated_files
        end

        # @return [<Metadata::METS::Elements::File>]
        def enumerated_files
          each_file.to_a
        end
      end
    end
  end
end
