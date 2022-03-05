# frozen_string_literal: true

module Harvesting
  module Metadata
    # A collection of common XML namespaces we use in the application.
    #
    # @see Harvesting::Types::XMLNamespace
    module Namespaces
      extend Dry::Container::Mixin

      # @see https://jats.nlm.nih.gov/publishing/1.2/
      JATS_12 = "https://jats.nlm.nih.gov/publishing/1.2/"

      register(:jats, JATS_12)

      # @see http://www.loc.gov/METS/
      METS = "http://www.loc.gov/METS/"

      register(:mets, METS)

      # @see http://www.loc.gov/mods/v3
      MODS = ::Mods::MODS_NS

      register(:mods, MODS)

      # @see http://www.loc.gov/standards/premis
      PREMIS = "http://www.loc.gov/standards/premis"

      register(:premis, PREMIS)

      # @see https://www.w3.org/TR/xlink11/
      XLINK = "http://www.w3.org/1999/xlink"

      register(:xlink, XLINK)

      # @see http://www.w3.org/2001/XMLSchema-instance
      XSI = "http://www.w3.org/2001/XMLSchema-instance"

      register(:xsi, XSI)
    end
  end
end
