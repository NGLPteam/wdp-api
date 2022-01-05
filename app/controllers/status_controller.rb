# frozen_string_literal: true

# Endpoints for reporting on the status and health of the API.
class StatusController < ApplicationController
  # A ping endpoint.
  #
  # @return [void]
  def ping
    render json: { pong: true }
  end

  # The root endpoint.
  #
  # @return [void]
  def root
    render plain: <<~TEXT.strip_heredoc
    WDP-API
    TEXT
  end
end
