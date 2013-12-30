require_relative "helper"

Person = OpenStruct

class PersonSerializer < JsonSerializer
  attribute :name
end

setup do
  Person.new(name: "sonny")
end

test "serialized object includes root" do |person|
  result = { person: person.to_h }.to_json

  assert_equal result, PersonSerializer.new(person).to_json(root: :person)
end

test "serialized array includes root" do |person|
  result = { people: [person.to_h] }.to_json

  assert_equal result, PersonSerializer.new([person]).to_json(root: :people)
end
