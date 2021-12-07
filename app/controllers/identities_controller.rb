# frozen_string_literal: true

class IdentitiesController < ApplicationController
  before_action :authenticate_user!

  def show
    render json: @current_user.to_whoami
  end
end
