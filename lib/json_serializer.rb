require 'json'

class JsonSerializer
  def self.attribute name
    attributes << name if !attributes.include? name
  end

  def self.attributes
    @attributes ||= []
  end

  def self.association name, serializer
    associations[name] = serializer if !associations[name]
  end

  def self.associations
    @associations ||= {}
  end

  attr :object

  def initialize object
    @object = object
  end

  def to_json
    serializable_object.to_json
  end

  protected

  def serializable_object # :nodoc:
    if object.respond_to? :to_ary
      serializable_array
    else
      serializable_hash
    end
  end

  def serializable_hash # :nodoc:
    hash = attributes
    hash.merge! associations
  end

  def serializable_array # :nodoc:
    object.to_ary.map do |item|
      self.class.new(item).serializable_hash
    end
  end

  private

  def attributes
    self.class.attributes.each_with_object({}) do |name, hash|
      hash[name] = if self.class.method_defined? name
        self.send name
      else
        object.send name
      end
    end
  end

  def associations
    self.class.associations.each_with_object({}) do |(name, serializer), hash|
      hash[name] = serializer.new(object.send(name)).serializable_hash
    end
  end
end
