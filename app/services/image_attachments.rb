# frozen_string_literal: true

# An interface for dealing with image attachments in GraphQL.
#
# There are two top-level wrappers:
#
# * {ImageAttachments::ImageWrapper} — used for almost all images
# * {ImageAttachments::SiteLogoWrapper} — used specifically for the site logo. It has certain special variants
#   that must be used depending on whether the user chooses to show the title as well.
module ImageAttachments
  extend Dry::Container::Mixin

  register :formats, memoize: true do
    Constants::FORMATS.dup
  end

  namespace :images do
    register :sizes, memoize: true do
      Constants::IMAGE_SIZES.each_with_object({}) do |(size, (width, height)), h|
        h[size] = ImageAttachments::Size.new name: size, width: width, height: height
      end.freeze
    end
  end

  namespace :site_logos do
    register :sizes, memoize: true do
      Constants::SITE_LOGO_SIZES.each_with_object({}) do |(size, (width, height)), h|
        h[size] = ImageAttachments::Size.new name: size, width: width, height: height
      end.freeze
    end
  end

  register :sizes, memoize: true do
    resolve("images.sizes").merge(resolve("site_logos.sizes"))
  end

  class << self
    # @yieldparam [Symbol] format
    # @yieldreturn [void]
    def each_format
      return enum_for(__method__) unless block_given?

      self[:formats].each do |format|
        yield format
      end

      return self
    end

    # Iterate over the sizes used for {ImageAttachments::ImageWrapper}.
    #
    # @yieldparam [ImageAttachments::Size] size
    # @yieldreturn [void]
    def each_image_size
      return enum_for(__method__) unless block_given?

      self["images.sizes"].each_value do |size|
        yield size
      end

      return self
    end

    # Iterate over the sizes used for {ImageAttachments::SiteLogoWrapper}.
    #
    # @see ImageAttachments::Constants::SITE_LOGO_SIZES
    # @yieldparam [ImageAttachments::Size] size
    # @yieldreturn [void]
    def each_site_logo_size
      return enum_for(__method__) unless block_given?

      self["site_logos.sizes"].each_value do |size|
        yield size
      end

      return self
    end

    # @see #each_image_size
    # @see #each_site_logo_size
    # @param [ImageAttachments::Types::Scope] scope
    # @return [void]
    def each_scoped_size(scope, &block)
      case scope
      when :image
        each_image_size(&block)
      when :site_logo
        each_site_logo_size(&block)
      else
        raise "Unknown scope: #{scope.inspect}"
      end
    end

    # Iterate over *all* sizes used for all wrappers.
    #
    # @see #each_image_size
    # @see #each_site_logo_size
    # @yieldparam [ImageAttachments::Size] size
    # @yieldreturn [void]
    def each_size
      return enum_for(__method__) unless block_given?

      each_image_size do |size|
        yield size
      end

      each_site_logo_size do |size|
        yield size
      end

      return self
    end

    # @param [Symbol] name
    # @return [ImageAttachments::Size]
    def image_size(name)
      self["images.sizes"].fetch name
    end

    # @param [Symbol] name
    def image_size?(name)
      self["images.sizes"].key? name
    end

    # @param [Symbol] name
    # @return [ImageAttachments::Size]
    def site_logo_size(name)
      self["site_logos.sizes"].fetch name
    end

    # @param [Symbol] name
    def site_logo_size?(name)
      self["site_logos.sizes"].key? name
    end
  end
end
