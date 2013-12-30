require "json"

class JsonSerializer
  # Specifies which attributes you would like to include in the outputted JSON.
  #
  #   class UserSerializer < JsonSerializer
  #     attribute :id
  #     attribute :username
  #   end
  #
  #   user = User.create(username: "skrillex", admin: true)
  #
  #   UserSerializer.new(user).to_json
  #   # => {"id":1,"username":"skrillex"}
  #
  # By default, before looking up the attribute on the object, checks the presence
  # of a method with the attribute name. This allow serializers to include properties
  # in addition to the object attributes or customize the result of a specified
  # attribute. You can access the object being serialized with the +object+ method.
  #
  #   class UserSerializer < JsonSerializer
  #     attribute :id
  #     attribute :username
  #     attribute :full_name
  #
  #     def full_name
  #       object.first_name + " " + object.last_name
  #     end
  #   end
  #
  #   user = User.create(username: "skrillex", first_name: "sonny", last_name: "moore")
  #
  #   UserSerializer.new(user).to_json
  #   # => {"id":1,"username":"skrillex","full_name":"sonny moore"}
  #
  def self.attribute(name, serializer = nil)
    attributes[name] ||= serializer
  end

  # Returns an array with the specified attributes by +attribute+.
  #
  #   class UserSerializer < JsonSerializer
  #     attribute :id
  #     attribute :username
  #   end
  #
  #   UserSerializer.attributes
  #   # => [:id, :username, :github]
  #
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

  def serializable_object # :nodoc:
    if object.respond_to?(:to_ary)
      object.to_ary.map { |item| self.class.new(item).attributes }
    else
      attributes
    end
  end

  def attributes # :nodoc:
    self.class.attributes.each_with_object({}) do |(name, serializer), hash|
      data = self.class.method_defined?(name) ? self.send(name) : object.send(name)
      data = Utils.const(self.class, serializer).new(data).serializable_object if serializer
      hash[name] = data
    end
  end

  module Utils # :nodoc
    def self.const(context, name)
      case name
      when Symbol, String
        context.const_get(name)
      else name
      end
    end
  end
end
