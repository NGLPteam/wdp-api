# frozen_string_literal: true

namespace :release do
  desc "Reload system dependencies"
  task reload_system: :environment do
    WDPAPI::Container["system.reload_everything"].().value!
  end

  desc "Deploy task for heroku and similar environments"
  task post_deploy: %i[environment db:migrate release:reload_system] do
    warn "Deployed"
  end
end
