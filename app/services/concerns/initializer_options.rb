# frozen_string_literal: true

# A helper module for retrieving the options provided
# to a class that uses `Dry::Initializer`.
#
# @api private
module InitializerOptions
  extend ActiveSupport::Concern

  # Retrieve the (publicly-accessible) options provided to this object's initializer.
  # @return [{ Symbol => Object }]
  def initializer_options
    self.class.dry_initializer.options.each_with_object({}) do |option, h|
      next unless option.reader == :public

      h[option.source] = public_send(option.source)
    end
  end
end
