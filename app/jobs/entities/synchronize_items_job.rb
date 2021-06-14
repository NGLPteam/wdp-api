# frozen_string_literal: true

module Entities
  class SynchronizeItemsJob < ApplicationJob
    include SynchronizesEntity

    model Item
  end
end
