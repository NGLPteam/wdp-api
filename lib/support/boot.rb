# frozen_string_literal: true

Pathname(__dir__).join("boot").glob("**/*.rb").sort.each do |initializer|
  require initializer
end
