# frozen_string_literal: true

module ReloadAfterSave
  extend ActiveSupport::Concern

  included do
    after_save :reload
  end
end
