# frozen_string_literal: true

module InitializerOptions
  extend ActiveSupport::Concern

  def initializer_options
    self.class.dry_initializer.options.each_with_object({}) do |option, h|
      next unless option.reader == :public

      h[option.source] = public_send(option.source)
    end
  end
end
