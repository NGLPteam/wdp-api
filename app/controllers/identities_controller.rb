# frozen_string_literal: true

# A controller for testing identities through JWT.
#
# @api private
class IdentitiesController < ApplicationController
  before_action :authenticate_user!

  # An endpoint that provides information about a user based on their provided JWT.
  def show
    render json: @current_user.to_whoami
  end
end
