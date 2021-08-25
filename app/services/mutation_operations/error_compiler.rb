# frozen_string_literal: true

module MutationOperations
  class ErrorCompiler
    include Dry::Initializer.define -> do
      option :attribute_names, AppTypes::Array.of(AppTypes::String)
    end

    include WDPAPI::Deps[normalize_path: "mutations.utility.normalize_path"]

    GLOBAL_PATH = %w[$global].freeze

    # @param [String] message
    # @param [String, #to_s, nil] code
    # @param [<String, #to_s>, nil] path
    # @return [MutationOperations::UserError]
    def call(message, code: nil, path: nil)
      path = normalize_path.call path

      attribute_path = path.join(?.)

      error = MutationOperations::UserError.new(
        message: message,
        code: code,
        path: path,
        attribute_path: attribute_path,
        global: !attribute_path.in?(attribute_names)
      )

      return error
    end

    # @return [MutationOperations::UserError]
    def global(message)
      MutationOperations::UserError.new(
        message: message,
        code: nil,
        path: GLOBAL_PATH,
        attribute_path: "$global",
        global: true
      )
    end
  end
end
