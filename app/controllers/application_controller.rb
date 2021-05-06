# frozen_string_literal: true

class ApplicationController < ActionController::API
  include OperationHelpers

  def authenticate_user!
    perform_operation "users.authenticate", request.env do |m|
      m.success do |user|
        @current_user = user
      end

      m.failure do |code, errors|
        render json: { errors: [{ message: "Failed to Authenticate" }] }, status: :forbidden
      end
    end
  end
end
