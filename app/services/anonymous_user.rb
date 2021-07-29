# frozen_string_literal: true

AnonymousUser = Naught.build do |config|
  include AnonymousInterface

  config.mimic User

  config.predicates_return false
end

AnonymousUser.extend AnonymousInterface::ClassMethods
