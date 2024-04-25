# frozen_string_literal: true

module Patches
  # This is an attempt to solve a weird incompatibility with dry-effects / fibers
  # and ActiveRecord / ActiveSupport, and moreover, its reliance on Ruby's Monitor,
  # which is a bit older and not compatible with newer concurrency paradigms.
  #
  # The entire point of the LoadInterlockAwareMonitor appears to be mostly for
  # runtimes other than MRI/CRuby, and so we shouldn't really need to worry about it.
  #
  # Removing the monitor / mutex solves a problem that was causing weird issues that
  # cannot be replicated in RSpec, but happen in dev and production environments.
  module DisableSynchronize
    def synchronize(&)
      Thread.handle_interrupt({ Exception => :never }) do
        # mon_enter

        Thread.handle_interrupt({ Exception => :immediate }, &)

        # mon_exit
      end
    end

    class << self
      def should_apply?
        # :nocov:
        return true if Rails.env.test?

        return false if puma?

        return true
      end

      def puma?
        $PROGRAM_NAME.match?("puma") || ARGV.grep(/puma/).present?
      end
    end
  end
end

ActiveSupport::Concurrency::LoadInterlockAwareMonitor.prepend(Patches::DisableSynchronize) if Patches::DisableSynchronize.should_apply?
