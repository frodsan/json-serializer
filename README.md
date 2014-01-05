json-serializer
===============

Customizes JSON output through serializer objects.  A minimal implementation of
[active_model_serializers][active_model_serializers] gem.

Installation
------------

```
gem install json-serializer
```

Usage
-----

Here's a simple example:

```
class UserSerializer < JsonSerializer
  attribute :id
  attribute :first_name
  attribute :last_name
end
```

In this case, we defined a new serializer class and specified the attributes
we would like to include in the serialized form.

```
user = User.create(first_name: "Sonny", last_name: "Moore", admin: true)

UserSerializer.new(user).to_json
# => "{\"id\":1,\"first_name\":\"Sonny\",\"last_name\":\"Moore\"}"
```

By default, before looking up the attribute on the object, checks the presence
of a method with the name of the attribute. This allow serializes to include
properties in addition to the object attributes or customize the result of a
specified attribute. You can access the object being serialized with the +object+
method.

```
class UserSerializer < JsonSerializer
  attribute :id
  attribute :first_name
  attribute :last_name
  attribute :full_name

  def full_name
    object.first_name + " " + object.last_name
  end
end

user = User.create(first_name: "Sonny", last_name: "Moore")

UserSerializer.new(user).to_json
# => "{\"id\":1,\"first_name\":\"Sonny\",\"last_name\":\"Moore\",\"full_name\":\"Sonny Moore\"}"
```

[active_model_serializers](https://github.com/rails-api/active_model_serializers)
