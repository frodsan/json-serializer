require 'cutest'
require_relative '../lib/presenters'

Post = Struct.new :id

class PostPresenter < Presenter
  attribute :id
end

test 'define method for given attribute' do
  post = Post.new 1
  presenter = PostPresenter.new post

  assert_equal post.id, presenter.id
end
