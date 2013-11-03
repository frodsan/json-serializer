require 'cutest'
require_relative '../lib/json_serializer'

Post = Struct.new :id, :title, :created_at

class PostSerializer < JsonSerializer
  attribute :id
  attribute :title
  attribute :slug

  def slug
    "#{ object.id }-#{ object.title }"
  end
end

test 'converts defined attributes into json' do
  post = Post.new 1, 'tsunami'
  serializer = PostSerializer.new post

  result = {
    id: 1,
    title: 'tsunami',
    slug: '1-tsunami'
  }

  assert_equal result.to_json, serializer.to_json
end

User = Struct.new :id, :name, :lastname

class UserSerializer < JsonSerializer
  attribute :id
  attribute :fullname

  def fullname
    object.name + ' ' + object.lastname
  end
end

test 'serializes array' do
  users = [
    User.new(1, 'sonny', 'moore'),
    User.new(2, 'anton', 'zaslavski')
  ]

  serializer = UserSerializer.new users

  result = [
    { id: 1, fullname: 'sonny moore' },
    { id: 2, fullname: 'anton zaslavski' }
  ].to_json

  assert_equal result, serializer.to_json
end
