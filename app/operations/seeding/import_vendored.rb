# frozen_string_literal: true

module Seeding
  # Import one of the vendored seed files in `./vendor/seeds`.
  class ImportVendored
    include Dry::Monads[:result, :do]
    include MeruAPI::Deps[
      run: "seeding.import.run",
    ]

    # @api private
    VENDOR_PATH = Rails.root.join("vendor/seeds")

    # @param [String] name
    # @return [Dry::Monads::Result]
    def call(name)
      path = yield path_for name

      run.call(path)
    end

    private

    # @param [String] name
    # @return [Dry::Monads::Success(Pathname)]
    def path_for(name)
      basename = basename_for name

      path = VENDOR_PATH.join basename

      return Failure[:seed_not_found, "#{name}: #{path} does not exist"] unless path.exist?

      Success path
    end

    # @param [String] name
    # @return [String]
    def basename_for(name)
      ext = File.extname(name)

      ext.blank? ? "#{name}.json" : name
    end
  end
end
