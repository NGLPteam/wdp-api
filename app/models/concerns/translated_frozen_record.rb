# frozen_string_literal: true

module TranslatedFrozenRecord
  extend ActiveSupport::Concern

  def fetch_translated_attribute(key)
    options = {
      scope: i18n_attribute_scope,
    }

    default_method = :"default_#{key}"

    if respond_to?(default_method, true)
      options[:default] = __send__ default_method
    else
      options[:default] = nil
    end

    I18n.t(key, options)&.strip
  end

  # @api private
  # @!attribute [r] i18n_scope
  # @return [String]
  def i18n_attribute_scope
    build_i18n_attribute_scope
  end

  private

  # @return [String]
  def build_i18n_attribute_scope
    [self.class.i18n_scope, self.class.model_i18n_key, primary_key_for_i18n].join(?.)
  end

  def primary_key_for_i18n
    id
  end

  module ClassMethods
    # @!macro [attach]
    #   @!attribute [r] name
    #   A translated attribute. See config/locales for values.
    #   @return [String]
    def has_translated!(name)
      class_eval <<~RUBY, __FILE__, __LINE__ + 1
      def #{name}                                   # def label
        fetch_translated_attribute(#{name.inspect}) #   fetch_translated_attribute :label
      end                                           # end
      RUBY
    end

    # @api private
    # @return [Symbol]
    def i18n_scope
      :frozen
    end

    # @api private
    # @abstract
    # @return [Symbol]
    def model_i18n_key
      model_name.i18n_key
    end
  end
end
