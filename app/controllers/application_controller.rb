# frozen_string_literal: true

class ApplicationController < ActionController::API
  include OperationHelpers

  def authenticate_user!
    perform_operation "users.authenticate", request.env do |m|
      m.success do |user|
        @current_user = user
      end

      m.failure(:expired) do
        render_server_message! "tokens.expired", status: :unauthorized
      end

      m.failure do |code, errors|
        render_server_message! "tokens.invalid", status: :forbidden
      end
    end
  end

  def render_server_message!(key, **options)
    render_single_error! I18n.t(key, scope: "server_messages"), **options
  end

  def render_single_error!(message, status: :internal_server_error, **props)
    render json: { errors: [{ **props, message: message } ] }, status: status
  end
end
