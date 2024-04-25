# frozen_string_literal: true

module Testing
  module HushActiveRecord
    def call(...)
      ActiveRecord::Base.logger.silence do
        super
      end
    end
  end
end
