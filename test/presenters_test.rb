require 'cutest'
require_relative '../lib/presenters'

User = Struct.new :id, :name, :lastname

class UserPresenter < Presenter
  attribute :id
  attribute :fullname

  def fullname
    object.name + ' ' + object.lastname
  end
end

test 'defines method for given attribute' do
  user = User.new 1
  presenter = UserPresenter.new user

  assert_equal user.id, presenter.id
end

test 'returns listed attributes and their values' do
  user = User.new 1, 'sonny', 'moore'
  presenter = UserPresenter.new user

  result = { id: 1, fullname: 'sonny moore' }

  assert_equal result, presenter.attributes
end
