# frozen_string_literal: true

module Metadata
  # @abstract
  class AbstractMapper < Lutaml::Model::Serializable
    extend Dry::Core::ClassAttributes

    include Dry::Core::Constants
  end
end
