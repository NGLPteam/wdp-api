# frozen_string_literal: true

module Roles
  class Mapper
    def call
      yield self

      return roles.values
    end

    def role!(identifier, **options, &block)
      definer = Roles::Definer.new(identifier, **options)

      roles[definer.identifier] = definer.call(&block)

      return nil
    end

    private

    def roles
      @roles ||= {}
    end
  end
end
