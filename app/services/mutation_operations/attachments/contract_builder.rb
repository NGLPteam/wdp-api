# frozen_string_literal: true

module MutationOperations
  module Attachments
    class ContractBuilder
      include Dry::Initializer[undefined: false].define -> do
        param :name, AppTypes::Symbol

        option :image, AppTypes::Bool, default: false, optional: true
      end

      def call
        attachment_name = name

        clear_attachment = :"clear_#{name}"

        contract = Class.new(ApplicationContract) do
          json do
            optional(clear_attachment).maybe(:bool)
            optional(attachment_name).maybe(:hash)
          end

          rule(clear_attachment, attachment_name) do
            key(attachment_name).failure(:update_and_clear_attachment) if values[clear_attachment].present? && values[attachment_name].present?
          end
        end

        contract.new
      end
    end
  end
end
