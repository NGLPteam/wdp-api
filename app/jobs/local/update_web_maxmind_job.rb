# frozen_string_literal: true

module Local
  class UpdateWebMaxmindJob
    include SuckerPunch::Job

    max_jobs 2

    def perform
      MeruAPI::Container["local.update_web_maxmind"].().value!
    end
  end
end
