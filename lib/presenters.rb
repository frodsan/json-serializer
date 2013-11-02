class Presenter
  def self.attribute name
    return if attributes.include? name

    attributes << name

    define_method name do
      object.send name
    end if !method_defined? name
  end

  def self.attributes
    @attributes ||= []
  end

  attr :object

  def initialize object
    @object = object
  end

  def attributes
    self.class.attributes.each_with_object({}) do |name, hash|
      hash[name] = send name
    end
  end
end
