require_relative "helper"

class PersonSerializer < JsonSerializer
  attribute :name
end

class RootTest < Minitest::Test
  setup do
    @person = Person.new(name: "sonny")
  end

  test "serialized object includes root" do
    result = { person: @person.to_h }.to_json

    assert_equal result, PersonSerializer.new(@person).to_json(root: :person)
  end

  test "serialized array includes root" do
    result = { people: [@person.to_h] }.to_json

    assert_equal result, PersonSerializer.new([@person]).to_json(root: :people)
  end
end
