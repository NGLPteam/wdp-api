# frozen_string_literal: true

module View
  extend ActiveSupport::Concern

  def readonly?
    true
  end
end
