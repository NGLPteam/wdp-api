# frozen_string_literal: true

namespace :pilot_harvesting do
  desc "Enqueue a seed job"
  task :seed, %i[seed_name] => :environment do |t, args|
    seed_name = args[:seed_name]

    raise "must provide seed name" if seed_name.blank?

    PilotHarvesting::SeedJob.perform_later seed_name
  end
end
