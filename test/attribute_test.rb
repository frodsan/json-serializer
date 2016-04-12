# frozen_string_literal: true

require_relative "helper"

class PostSerializer < JsonSerializer
  attribute :id
  attribute :title
  attribute :slug

  def slug
    "#{ object.id }-#{ object.title }"
  end
end

class ParentSerializer < JsonSerializer
  attribute :parent
end

class ChildSerializer < ParentSerializer
  attribute :child
end

class UserSerializer < JsonSerializer
  attribute :id
  attribute :fullname

  def fullname
    object.name + " " + object.lastname
  end
end

class AttributeTest < Minitest::Test
  test "converts defined attributes into json" do
    post = Post.new(id: 1, title: "tsunami")

    result = {
      id: 1,
      title: "tsunami",
      slug: "1-tsunami"
    }.to_json

    assert_equal result, PostSerializer.new(post).to_json
  end

  test "serializes array" do
    users = [
      User.new(id: 1, name: "sonny", lastname: "moore"),
      User.new(id: 2, name: "anton", lastname: "zaslavski")
    ]

    result = [
      { id: 1, fullname: "sonny moore" },
      { id: 2, fullname: "anton zaslavski" }
    ].to_json

    assert_equal result, UserSerializer.new(users).to_json
  end

  test "inheritance" do
    parent = ParentSerializer.attributes
    child = ChildSerializer.attributes

    assert_equal(parent.merge(child: nil), child)
  end
end
