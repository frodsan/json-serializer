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

  def to_json options={}
    if root = options.delete(:root)
      { root => serializable_object }.to_json options
    else
      serializable_object.to_json options
    end
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
    attributes.merge associations
  end

  def serializable_array # :nodoc:
    object.to_ary.map { |item| self.class.new(item).serializable_hash }
  end

  private

  def attributes
    self.class.attributes.each_with_object({}) do |name, hash|
      hash[name] = result_from_self_or_object name
    end
  end

  def associations
    self.class.associations.each_with_object({}) do |(name, serializer), hash|
      hash[name] = serializer.new(result_from_self_or_object(name)).serializable_object
    end
  end

  def result_from_self_or_object name
    self.class.method_defined?(name) ? self.send(name) : object.send(name)
  end
end
