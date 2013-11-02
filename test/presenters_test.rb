require 'cutest'
require_relative '../lib/presenters'

Post = Struct.new :id, :name, :lastname

class PostPresenter < Presenter
  attribute :id
  attribute :fullname

  def fullname
    object.name + ' ' + object.lastname
  end
end

test 'defines method for given attribute' do
  post = Post.new 1
  presenter = PostPresenter.new post

  assert_equal post.id, presenter.id
end

test 'returns listed attributes and their values' do
  post = Post.new 1, 'sonny', 'moore'
  presenter = PostPresenter.new post

  result = { id: 1, fullname: 'sonny moore' }

  assert_equal result, presenter.attributes
end
