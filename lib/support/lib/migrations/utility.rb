# frozen_string_literal: true

module Support
  module Migrations
    module Utility
      extend ActiveSupport::Concern

      # @param [#to_s] root
      # @param [{ Symbol => Object }] options
      # @option options [#to_s, nil] :prefix
      # @option options [#to_s, nil] :suffix
      # @return [Support::Migrations::TableRef]
      def table_ref(root, **options)
        return root if root.kind_of?(Support::Migrations::TableRef)

        Support::Migrations::TableRef.new(root, **options)
      end

      # @param [#to_s] root
      # @param [{ Symbol => Object }] options
      # @option options [#to_s, nil] :prefix
      # @option options [#to_s, nil] :suffix
      # @return [Support::Migrations::ColumnRef]
      def column_ref(root, **options)
        return root if root.kind_of?(Support::Migrations::ColumnRef)

        Support::Migrations::ColumnRef.new(root, **options)
      end

      # @api private
      # @param [Array] digestables
      # @return [Digest::MD5]
      def digest_for(*digestables)
        digestables.each_with_object(Digest::MD5.new) do |input, digest|
          output = to_digestable input

          next if output.blank?

          digest << output
        end
      end

      # @api private
      # @param [#unquoted, #to_s, nil] input
      # @return [String, nil]
      def to_digestable(input)
        case input
        when Support::Types.Interface(:unquoted) then input.unquoted
        when nil then nil
        else
          input.to_s
        end
      end
    end
  end
end
