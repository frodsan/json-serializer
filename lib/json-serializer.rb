require "json"

class JsonSerializer
  def self.attribute(name, serializer = nil)
    attributes[name] ||= serializer
  end

  def self.attributes
    @attributes ||= {}
  end

  attr :object

  def initialize(object)
    @object = object
  end

  def to_json(options={})
    if root = options[:root]
      { root => serializable_object }.to_json
    else
      serializable_object.to_json
    end
  end

  protected

  def serializable_object
    if object.respond_to?(:to_ary)
      object.to_ary.map { |item| self.class.new(item).attributes }
    else
      attributes
    end
  end

  def attributes
    self.class.attributes.each_with_object({}) do |(name, serializer), hash|
      data = self.class.method_defined?(name) ? self.send(name) : object.send(name)
      data = Utils.const(self.class, serializer).new(data).serializable_object if serializer
      hash[name] = data
    end
  end

  module Utils
    def self.const(context, name)
      case name
      when Symbol, String
        context.const_get(name)
      else name
      end
    end
  end
end
