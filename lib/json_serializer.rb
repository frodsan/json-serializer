# frozen_string_literal: true
require "json"

class JsonSerializer
  module Utils
    def self.const(context, name)
      case name
      when Symbol, String
        context.const_get(name)
      else name
      end
    end
  end

  def self.inherited(subclass)
    attributes.each do |name, serializer|
      subclass.attribute(name, serializer)
    end
  end

  def self.attribute(name, serializer = nil)
    attributes[name] ||= serializer
  end

  def self.attributes
    @attributes ||= {}
  end

  attr_reader :object

  def initialize(object)
    @object = object
  end

  def to_json(root: nil)
    result = serializable_object
    result = { root => result } if root

    result.to_json
  end

  protected

  def serializable_object
    return nil unless object

    if object.respond_to?(:to_a)
      object.to_a.map { |item| self.class.new(item).to_hash }
    else
      to_hash
    end
  end

  def to_hash
    self.class.attributes.each_with_object({}) do |(name, serializer), hash|
      data = self.class.method_defined?(name) ? send(name) : object.send(name)

      if serializer
        serializer_class = Utils.const(self.class, serializer)

        data = serializer_class.new(data).serializable_object
      end

      hash[name] = data
    end
  end
end
