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

class PostWithRootSerializer < JsonSerializer
  root :post

  attribute :id
  attribute :title
end

test 'defines root' do
  post = Post.new 1, 'tsunami'
  serializer = PostWithRootSerializer.new post

  result = { post: { id: 1, title: 'tsunami' } }.to_json

  assert_equal result, serializer.to_json
end
