# frozen_string_literal: true

module Templates
  # A way of getting at the prev/next siblings for a source entity
  # within a template instance.
  #
  # @see Templates::OrderingInstance
  # @see Templates::Instances::HasOrderingPair
  # @see Types::TemplateHasOrderingPairType
  # @see Types::TemplateOrderingPairType
  class OrderingPair
    include Dry::Core::Constants
    include Dry::Core::Equalizer.new(:instance)
    include Dry::Initializer[undefined: false].define -> do
      param :instance, Templates::Types::TemplateInstance
    end

    # @return [Integer]
    attr_reader :count

    # @return [Boolean]
    attr_reader :exists

    alias exists? exists

    # @return [Boolean]
    attr_reader :first

    alias first? first

    # @return [Boolean]
    attr_reader :last

    alias last? last

    # @return [Integer, nil]
    attr_reader :position

    # @return [HierarchicalEntity, nil]
    attr_reader :prev_sibling

    # @return [HierarchicalEntity, nil]
    attr_reader :next_sibling

    def initialize(...)
      super

      @count = instance.ordering_entry_count&.visible_count

      @exists = instance.ordering.present? && instance.ordering_entry.present?

      @position = instance.ordering_entry&.position

      @prev_sibling = instance.prev_sibling

      @next_sibling = instance.next_sibling

      @first = exists? && prev_sibling.blank?
      @last = exists? && next_sibling.blank?
    end
  end
end
