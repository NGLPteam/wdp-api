# frozen_string_literal: true

module Support
  module DefinesKlassNamePair
    extend ActiveSupport::Concern

    included do
      extend Dry::Core::ClassAttributes
      extend Dry::Core::Cache

      defines :klass_name_pairs, type: Support::Types::Array.of(Support::Types.Instance(KlassNamePair))

      klass_name_pairs [].freeze
    end

    def all_klass_name_pairs_exist?
      self.class.klass_name_pairs.all? do |mod|
        __send__(mod.exist_method)
      end
    end

    def check_klass_name_pairs
      self.class.klass_name_pairs.to_h do |mod|
        [
          __send__(mod.klass_name_method),
          __send__(mod.exist_method),
        ]
      end
    end

    # @api private
    def klass_name_pair_discriminator
      hash
    end

    module ClassMethods
      def klass_name_pair!(prefix, &)
        mod = KlassNamePair.new(prefix)

        define_method(mod.build_method, &)

        include mod

        curr = [mod, *klass_name_pairs].uniq

        klass_name_pairs curr.freeze
      end
    end

    # @api private
    class KlassNamePair < Module
      include Dry::Core::Equalizer.new(:prefix)

      include Dry::Initializer[undefined: false].define -> do
        param :prefix, Support::Types::Coercible::Symbol

        option :build_method, Support::Types::Symbol, default: proc { :"build_#{prefix}_klass_name" }
        option :klass_method, Support::Types::Symbol, default: proc { :"#{prefix}_klass" }
        option :klass_name_method, Support::Types::Symbol, default: proc { :"#{prefix}_klass_name" }
        option :exist_method, Support::Types::Symbol, default: proc { :"#{prefix}_klass_exists?" }
      end

      def included(base)
        base.class_eval <<~RUBY, __FILE__, __LINE__ + 1
        def #{exist_method}
          #{klass_method}
        rescue NameError
          false
        else
          true
        end

        def #{klass_method}
          fetch_or_store(klass_name_pair_discriminator, __method__) do
            #{klass_name_method}.constantize
          end
        end

        def #{klass_name_method}
          fetch_or_store(klass_name_pair_discriminator, __method__) do
            #{build_method}
          end
        end
        RUBY
      end
    end
  end
end
