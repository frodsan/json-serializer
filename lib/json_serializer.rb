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
    result = decorate
    result = { root => result } if root

    result.to_json
  end

  def decorate
    return nil unless object

    if object.respond_to?(:to_a)
      to_arry
    else
      to_hash
    end
  end

  protected

  def to_arry
    object.to_a.map { |o| self.class.new(o).to_hash }
  end

  def to_hash
    self.class.attributes.each_with_object({}) do |(name, serializer), hash|
      res = self.class.method_defined?(name) ? send(name) : object.send(name)
      res = Utils.const(self.class, serializer).new(res).decorate if serializer

      hash[name] = res
    end
  end
end
