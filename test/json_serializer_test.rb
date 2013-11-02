require 'cutest'
require_relative '../lib/json_serializer'

Post = Struct.new :id, :title

class PostPresenter < JsonSerializer
  attribute :id
  attribute :title
  attribute :slug

  def slug
    "#{ object.id }-#{ object.title }"
  end
end

test 'converts defined attributes into json' do
  post = Post.new 1, 'tsunami'
  presenter = PostPresenter.new post

  result = {
    id: 1,
    title: 'tsunami',
    slug: '1-tsunami'
  }

  assert_equal result.to_json, presenter.to_json
end

class PostWithRootPresenter < JsonSerializer
  root :post

  attribute :id
  attribute :title
end

test 'defines root' do
  post = Post.new 1, 'tsunami'
  presenter = PostWithRootPresenter.new post

  result = { post: post.to_h }.to_json

  assert_equal result, presenter.to_json
end
