require_relative "helper"

class OrganizationSerializer < JsonSerializer
  attribute :id
  attribute :name
end

class UserWithOrganizationSerializer < JsonSerializer
  attribute :id
  attribute :name
  attribute :organization, :OrganizationSerializer
end

class UserWithCustomOrganizationSerializer < JsonSerializer
  attribute :organizations, :OrganizationSerializer

  def organizations
    [Organization.new(id: 1, name: "enterprise")]
  end
end

class AssociationTest < Minitest::Test
  test "serializes object with association" do
    user = User.new(id: 1, name: "sonny")
    user.organization = Organization.new(id: 1, name: "enterprise")

    result = {
      id: 1,
      name: "sonny",
      organization: {
        id: 1,
        name: "enterprise"
      }
    }.to_json

    assert_equal result, UserWithOrganizationSerializer.new(user).to_json
  end

  test "serializes object with a nil association" do
    user = User.new(id: 1, name: "sonny")
    user.organization = nil

    result = {
      id: 1,
      name: "sonny",
      organization: nil
    }.to_json

    assert_equal result, UserWithOrganizationSerializer.new(user).to_json
  end

  test "serializes array with association" do
    users = [
      User.new(id: 1, name: "sonny", organization: Organization.new(id: 1, name: "enterprise")),
      User.new(id: 2, name: "anton", organization: Organization.new(id: 2, name: "evil"))
    ]

    result = [
      {
        id: 1,
        name: "sonny",
        organization: {
          id: 1,
          name: "enterprise"
        }
      },
      {
        id: 2,
        name: "anton",
        organization: {
          id: 2,
          name: "evil"
        }
      }
    ].to_json

    assert_equal result, UserWithOrganizationSerializer.new(users).to_json
  end

  class UserWithOrganizationsSerializer < JsonSerializer
    attribute :id
    attribute :name
    attribute :organizations, :OrganizationSerializer
  end

  test "serializes object with collection" do
    user = User.new(id: 1, name: "sonny")
    user.organizations = [
      Organization.new(id: 1, name: "enterprise"),
      Organization.new(id: 2, name: "evil")
    ]

    result = {
      id: 1,
      name: "sonny",
      organizations: [
        {
          id: 1,
          name: "enterprise"
        },
        {
          id: 2,
          name: "evil"
        }
      ]
    }.to_json

    assert_equal result, UserWithOrganizationsSerializer.new(user).to_json
  end

  test "serializes array with nested collections" do
    users = [
      User.new(
        id: 1,
        name: "sonny",
        organizations: [
          Organization.new(id: 1, name: "enterprise"),
          Organization.new(id: 2, name: "evil"),
        ]
      ),
      User.new(
        id: 2,
        name: "anton",
        organizations: [
          Organization.new(id: 3, name: "showtek")
        ]
      )
    ]

    result = [
      {
        id: 1,
        name: "sonny",
        organizations: [
          {
            id: 1,
            name: "enterprise"
          },
          {
            id: 2,
            name: "evil"
          }
        ]
      },
      {
        id: 2,
        name: "anton",
        organizations: [
          {
            id: 3,
            name: "showtek"
          }
        ]
      }
    ].to_json

    assert_equal result, UserWithOrganizationsSerializer.new(users).to_json
  end

  test "implements association method and returns different result" do
    user = User.new

    result = { organizations: [ { id: 1, name: "enterprise" } ] }.to_json

    assert_equal result, UserWithCustomOrganizationSerializer.new(user).to_json
  end
end
