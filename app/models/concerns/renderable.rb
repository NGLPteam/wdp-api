# frozen_string_literal: true

module Renderable
  extend ActiveSupport::Concern

  included do
    scope :rendered_in_the_last, ->(interval) { where(arel_table[:last_rendered_at].gteq(Time.current - interval)) }
  end

  # @return [void]
  def track_render!(last_rendered_at: Time.current)
    render_duration = AbsoluteTime.realtime do
      yield
    end

    update_columns(render_duration:, last_rendered_at:)
  end
end
