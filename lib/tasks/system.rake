# frozen_string_literal: true

namespace :system do
  desc "Vacuum the database asynchronously"
  task vacuum_full: :environment do
    System::VacuumFullJob.perform_later
  end
end
