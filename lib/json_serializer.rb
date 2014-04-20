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
    if object.kind_of?(Enumerable)
      object.to_a.map { |item| self.class.new(item).to_hash }
    else
      to_hash
    end
  end

  def to_hash
    self.class.attributes.each_with_object({}) do |(name, serializer), hash|
      return unless object

      data = self.class.method_defined?(name) ? self.send(name) : object.send(name)
      data = Utils.const(self.class, serializer).new(data).serializable_object if serializer
      hash[name] = data
    end
  end
end
