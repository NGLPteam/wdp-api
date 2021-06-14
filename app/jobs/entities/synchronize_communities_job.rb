# frozen_string_literal: true

module Entities
  class SynchronizeCommunitiesJob < ApplicationJob
    include SynchronizesEntity

    model Community
  end
end
