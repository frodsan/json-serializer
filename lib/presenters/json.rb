require 'json'

class JsonPresenter < Presenter
  def self.root key
    @root = key
  end

  def self.root_key
    @root
  end

  def to_json
    if root = self.class.root_key
      { root => attributes }.to_json
    else
      attributes.to_json
    end
  end
end
