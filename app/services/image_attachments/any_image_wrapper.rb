# frozen_string_literal: true

module ImageAttachments
  # A type for matching {ImageWrapper} or {SiteLogoWrapper}.
  AnyImageWrapper = ImageWrapper::Type | SiteLogoWrapper::Type
end
