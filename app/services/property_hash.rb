# frozen_string_literal: true

# Extracted from an in-progress gem.
class PropertyHash
  include Enumerable

  KEY_PATH = /\A[^.]+(?:\.[^.]+)+\z/.freeze
  DOT_PATH = /\./.freeze
  SINGLE_PATH = /\A[^.]+\z/.freeze

  def initialize(base_hash = {})
    @inner = {}

    Hash(base_hash).deep_stringify_keys.each do |key, value|
      self[key] = value
    end
  end

  def [](path)
    case path
    when KEY_PATH
      parts = path.to_s.split(?.)

      @inner.dig(*parts)
    when SINGLE_PATH
      @inner[path.to_s]
    when nil then nil
    when DOT_PATH
      # :nocov:
      raise InvalidPath, "Confusing key: #{path.inspect}"
      # :nocov:
    else
      # :nocov:
      raise InvalidPath, "Cannot get path from: #{path.inspect}"
      # :nocov:
    end
  end

  def []=(path, value)
    case path
    when KEY_PATH
      *parts, key = path.to_s.split(?.)

      incr_path = []

      target_hash = parts.reduce(@inner) do |h, k|
        incr_path << k

        inner_h = h[k] ||= {}

        next inner_h if inner_h.kind_of?(Hash)

        # :nocov:
        raise InvalidNesting.new inner_h, incr_path
        # :nocov:
      end

      target_hash[key] = value

    when SINGLE_PATH
      @inner[path.to_s] = value
    when DOT_PATH
      # :nocov:
      raise InvalidPath, "Confusing key: #{path.inspect}"
      # :nocov:
    else
      # :nocov:
      raise InvalidPath, "Cannot get path from: #{path.inspect}"
      # :nocov:
    end
  end

  def blank?
    @inner.blank?
  end

  def each
    return enum_for(__method__) unless block_given?

    derive_path_hash.each do |key, value|
      yield key, value
    end
  end

  def merge(other)
    other_hash = other.kind_of?(PropertyHash) ? other : PropertyHash.new(other)

    new_hash = PropertyHash.new

    each do |key, value|
      new_hash[key] = value
    end

    other_hash.each do |key, value|
      new_hash[key] = value
    end

    return new_hash
  end

  alias | merge

  def merge!(other)
    other_hash = other.kind_of?(PropertyHash) ? other : PropertyHash.new(other)

    other_hash.each do |key, value|
      self[key] = value
    end

    return self
  end

  def paths
    derive_path_hash.keys
  end

  def to_h
    @inner.to_h
  end

  alias to_hash to_h

  protected

  attr_reader :inner

  private

  def derive_path_hash
    calculate_nested_paths with: @inner
  end

  def calculate_nested_paths(with:, on: {}, parent: [])
    with.each_with_object(on) do |(key, value), h|
      path = [*parent, key]

      case value
      when Hash
        calculate_nested_paths(with: value, on: h, parent: path)
      else
        full_path = path.join(?.)

        h[full_path] = value
      end
    end
  end

  class InvalidPath < KeyError; end

  class InvalidNesting < TypeError
    # @param [Object] found_object something that is not a hash
    # @param [<String>] path
    def initialize(found_object, path)
      @found_object = found_object
      @path = path.join(?.)

      super("Got #{@found_object.inspect} at #{@path}, expected a hash")
    end
  end
end
