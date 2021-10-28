# frozen_string_literal: true

module Digestable
  extend ActiveSupport::Concern

  def digest_with
    return unless digestable?

    Digest::SHA256.new.tap do |dig|
      yield dig if block_given?
    end.hexdigest
  end

  def digestable?
    true
  end
end
