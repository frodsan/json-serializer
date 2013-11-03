require 'json'

class JsonSerializer
  def self.attribute name
    attributes << name if !attributes.include? name
  end

  def self.attributes
    @attributes ||= []
  end

  attr :object

  def initialize object
    @object = object
  end

  def to_json
    serializable_object.to_json
  end

  def serializable_object # :nodoc
    if object.respond_to? :to_ary
      SerializableArray
    else
      SerializableHash
    end.new(object, self).serializable_object
  end

  private

  class Serializable
    attr :object, :serializer

    def initialize object, context
      @object  = object
      @context = context
    end
  end

  class SerializableHash < Serializable
    def serializable_object
      context.class.attributes.each_with_object({}) do |name, hash|
        hash[name] = if context.class.method_defined? name
          context.send name
        else
          object.send name
        end
      end
    end
  end

  class SerializableArray < Serializable
    def serializable_object
      object.to_ary.map do |item|
        context.class.new(item).serializable_object
      end
    end
  end
end
