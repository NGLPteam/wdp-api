# frozen_string_literal: true

# A concern for signifying an object that can have a fingerprint-like digest generated from it.
module Digestable
  extend ActiveSupport::Concern

  # Generate a digest programmatically.
  #
  # @yield [digest] Augment the digest for a specific instance
  # @yieldparam [Digest::SHA256] digest
  # @yieldreturn [void]
  # @return [String] a hexadecimal-encoded SHA256 fingerprint
  def digest_with
    return unless digestable?

    Digest::SHA256.new.tap do |dig|
      yield dig if block_given?
    end.hexdigest
  end

  # @abstract This method can be overridden if necessary to mark a specific instance
  #   as being incapable of generating a digest.
  def digestable?
    true
  end
end
