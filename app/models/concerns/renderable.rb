# frozen_string_literal: true

module Renderable
  extend ActiveSupport::Concern

  included do
    define_model_callbacks :render

    scope :rendered_in_the_last, ->(interval) { where(arel_table[:last_rendered_at].gteq(Time.current - interval)) }

    around_render :track_render_time!
  end

  # @return [void]
  def track_render!
    run_callbacks :render do
      yield
    end
  end

  def track_render_time!(last_rendered_at: Time.current)
    render_duration = AbsoluteTime.realtime do
      yield
    end

    update_columns(render_duration:, last_rendered_at:)
  end
end
