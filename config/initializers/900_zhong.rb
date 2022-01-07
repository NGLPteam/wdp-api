# frozen_string_literal: true

Zhong.redis = Redis.new(url: ENV["REDIS_URL"], db: 1)

Zhong.schedule do
  category "entities" do
    every 10.minutes, "populate_missing_orderings" do
      Entities::PopulateMissingOrderingsJob.perform_later
    end
  end
end
