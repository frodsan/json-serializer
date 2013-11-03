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

  def serializable_object
    if object.respond_to? :to_ary
      serializable_array
    else
      serializable_hash
    end
  end

  def serializable_hash
    self.class.attributes.each_with_object({}) do |name, hash|
      hash[name] = if self.class.method_defined? name
        self.send name
      else
        object.send name
      end
    end
  end

  def serializable_array
    object.to_ary.map do |item|
      self.class.new(item).serializable_hash
    end
  end
end
