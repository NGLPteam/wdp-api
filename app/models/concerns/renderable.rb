# frozen_string_literal: true

module Renderable
  extend ActiveSupport::Concern
  extend DefinesMonadicOperation

  included do
    extend Dry::Core::ClassAttributes

    defines :render_log_model, type: Rendering::Types::Class

    render_log_model MeruAPI::Container["rendering.find_render_log_model"].(self).value!

    define_model_callbacks :render

    scope :rendered_in_the_last, ->(interval) { where(arel_table[:last_rendered_at].gteq(Time.current - interval)) }

    around_render :track_render_time!
  end

  monadic_operation! def log_render(generation:, render_duration:)
    call_operation("rendering.log", self, generation:, render_duration:)
  end

  # @return [String]
  attr_reader :pending_generation

  # @return [Class(RenderLog)]
  def render_log_model
    self.class.render_log_model
  end

  # @return [void]
  def track_render!(generation:)
    @pending_generation = generation

    run_callbacks :render do
      yield
    end
  ensure
    @pending_generation = nil
  end

  def track_render_time!
    render_duration = AbsoluteTime.realtime do
      yield
    end

    last_rendered_at = Time.current

    update_columns(generation: pending_generation, last_rendered_at:, render_duration:)

    log_render(generation: pending_generation, render_duration:)
  end
end
