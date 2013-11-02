require 'json'

class JsonSerializer
  def self.attribute name
    attributes << name if !attributes.include? name
  end

  def self.attributes
    @attributes ||= []
  end

  def self.root key
    @root = key
  end

  def self.root_key
    @root
  end

  attr :object

  def initialize object
    @object = object
  end

  def attributes
    self.class.attributes.each_with_object({}) do |name, hash|
      hash[name] = object.send name
    end
  end

  def to_json
    if root = self.class.root_key
      { root => attributes }.to_json
    else
      attributes.to_json
    end
  end
end
