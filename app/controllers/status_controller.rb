# frozen_string_literal: true

class StatusController < ApplicationController
  def ping
    render json: { pong: true }
  end

  def root
    render plain: <<~TEXT.strip_heredoc
    WDP-API
    TEXT
  end
end
