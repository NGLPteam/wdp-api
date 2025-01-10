# frozen_string_literal: true

module Templates
  module Filters
    module CommonFilters
      CC_LICENSE_URL_MAPPING = {
        "CC BY" => "https://creativecommons.org/licenses/by/2.5/",
        "CC BY-SA" => "https://creativecommons.org/licenses/by-sa/2.5/",
        "CC BY-NC" => "https://creativecommons.org/licenses/by-nc/2.5/",
        "CC BY-NC-SA" => "https://creativecommons.org/licenses/by-nc-sa/2.5/",
        "CC BY-ND" => "https://creativecommons.org/licenses/by-nd/2.5/",
        "CC BY-NC-ND" => "https://creativecommons.org/licenses/by-nc-nd/2.5/"
      }.with_indifferent_access.freeze

      STANDARD = Object.new.tap do |x|
        x.extend Liquid::StandardFilters
      end

      # @param [String] label
      # @return [String]
      def cc_license_url(label)
        label = unwrap_property(label)

        CC_LICENSE_URL_MAPPING.fetch(label, "")
      end

      # @param [String] label
      # @return [String]
      def cc_license_link(label)
        label = unwrap_property(label)

        href = cc_license_url(label)

        # :nocov:
        return "" if href.blank?
        # :nocov:

        MeruAPI::Container["templates.mdx.build_anchor"].(href:, label:).value_or("")
      end

      def date(input, format)
        unwrapped = unwrap_date(input)

        STANDARD.date(unwrapped, format)
      end

      private

      # @return [Date, nil]
      def unwrap_date(value)
        # :nocov:
        case value
        when ::Templates::Drops::VariablePrecisionDateDrop, ::VariablePrecisionDate
          value.value
        else
          value
        end
        # :nocov:
      end

      # @param [Object] value
      # @return [Object]
      def unwrap_property(value)
        # :nocov:
        case value
        in Templates::Drops::PropertyValueDrop
          value.instance_variable_get(:@value)
        in Templates::Drops::VariablePrecisionDateDrop
          value.instance_variable_get(:@date)
        else
          value
        end
        # :nocov:
      end
    end
  end
end
