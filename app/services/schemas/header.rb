# frozen_string_literal: true

module Schemas
  # This stores information about a {SchemaVersion} for a {Schemas::Instances::PropertySet}.
  #
  # It is used to validate that a set of properties corresponds to the same schema version
  # the instance belongs to.
  #
  # @see SchemaVersion#to_header
  class Header
    include StoreModel::Model

    # @!attribute [rw] id
    # @return [String]
    attribute :id, :string

    # @!attribute [rw] namespace
    # @return [String]
    attribute :namespace, :string

    # @!attribute [rw] identifier
    # @return [String]
    attribute :identifier, :string

    # @!attribute [rw] version
    # @return [String]
    attribute :version, :string

    validates :id, :namespace, :identifier, :version, presence: true

    # @return [String]
    def full_declaration
      "#{namespace}:#{identifier}:#{version}"
    end

    def inspect
      "#<#{self.class}#{suffix}>"
    end

    alias to_s inspect

    # @return [String]
    def suffix
      "[#{full_declaration}]"
    end
  end
end
