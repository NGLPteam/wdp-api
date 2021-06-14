# frozen_string_literal: true

module Entities
  class SynchronizeCollectionsJob < ApplicationJob
    include SynchronizesEntity

    model Collection
  end
end
