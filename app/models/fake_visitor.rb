# frozen_string_literal: true

# A testing record used for simulating visit history.
#
# @api private
class FakeVisitor < ApplicationRecord
  belongs_to :user, optional: true

  scope :by_sequence, ->(value) { where(sequence: value) }

  def simulated_user
    user || AnonymousUser.new
  end

  # @return [{ Symbol => Object }]
  def to_simulator_options
    slice(:user_agent).merge(
      ip: ip.to_s,
      user: simulated_user,
    ).symbolize_keys
  end

  class << self
    # @yield [fake_visitor]
    # @yieldparam [FakeVisitor] fake_visitor
    # @yieldreturn [void]
    # @return [void]
    def find_each_in_sequence
      next_sequence.includes(:user).find_each do |fake_visitor|
        yield fake_visitor
      end
    end

    # @!attribute [r] global_sequencer
    # @return [Enumerator(Integer)]
    def global_sequencer
      @global_sequencer ||= sequencer
    end

    # @api private
    # @return [ActiveRecord::Relation<FakeVisitor>]
    def next_sequence
      by_sequence(global_sequencer.next)
    end

    # Sequences are used to group fake visitors into logical batches
    # for visit simulation across a wide variety of users and platforms.
    #
    # @return [Range(Integer)]
    def sequence_range
      @sequence_range ||= build_sequence_range
    end

    # @return [Enumerator(Integer)]
    def sequencer
      sequence_range.cycle
    end

    private

    # @return [Range(Integer)]
    def build_sequence_range
      min = 1
      max = Testing::RandomIPAddressSet.size / 2

      min..max
    end
  end
end
