# frozen_string_literal: true

module ImageAttachments
  extend Dry::Container::Mixin

  register :formats, memoize: true do
    Constants::FORMATS.dup
  end

  register :sizes, memoize: true do
    Constants::SIZES.each_with_object({}) do |(size, (width, height)), h|
      h[size] = ImageAttachments::Size.new name: size, width: width, height: height
    end.freeze
  end

  class << self
    # @yieldparam [Symbol] format
    # @yieldreturn [void]
    def each_format
      self[:formats].each do |format|
        yield format
      end

      return self
    end

    # @yieldparam [ImageAttachments::Size] size
    # @yieldreturn [void]
    def each_size
      self[:sizes].each_value do |size|
        yield size
      end

      return self
    end

    # @yieldparam [ImageAttachments::Size] size
    # @yieldparam [Symbol] format
    # @yieldreturn [void]
    def each_style
      self[:sizes].product(self[:formats]).each do |(size, format)|
        yield size, format
      end

      return self
    end

    # @param [Symbol] name
    # @return [ImageAttachments::Size]
    def size(name)
      self[:sizes].fetch name
    end

    def size?(name)
      self[:sizes].key? name
    end
  end
end
