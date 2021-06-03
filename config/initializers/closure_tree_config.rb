# frozen_string_literal: true

ClosureTree.configure do |config|
  # Heroku doesn't have the database available in every step
  config.database_less = true
end
