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

  result = {
    id: 1,
    title: 'tsunami',
    slug: '1-tsunami'
  }

  assert_equal result.to_json, PostSerializer.new(post).to_json
end

class User
  attr_accessor :id, :name, :lastname, :organization

  def initialize attrs
    attrs.each do |name, value|
      send "#{name}=", value
    end
  end
end

class UserSerializer < JsonSerializer
  attribute :id
  attribute :fullname

  def fullname
    object.name + ' ' + object.lastname
  end
end

test 'serializes array' do
  users = [
    User.new(id: 1, name: 'sonny', lastname: 'moore'),
    User.new(id: 2, name: 'anton', lastname: 'zaslavski')
  ]

  result = [
    { id: 1, fullname: 'sonny moore' },
    { id: 2, fullname: 'anton zaslavski' }
  ].to_json

  assert_equal result, UserSerializer.new(users).to_json
end

Organization = Struct.new :id, :name, :created_at

class OrganizationSerializer < JsonSerializer
  attribute :id
  attribute :name
end

class UserWithOrganizationSerializer < JsonSerializer
  attribute :id
  attribute :name

  association :organization, OrganizationSerializer
end

test 'serializes object with association' do
  user = User.new id: 1, name: 'sonny'
  user.organization = Organization.new 1, 'enterprise'

  result = {
    id: 1,
    name: 'sonny',
    organization: {
      id: 1,
      name: 'enterprise'
    }
  }.to_json

  assert_equal result, UserWithOrganizationSerializer.new(user).to_json
end
