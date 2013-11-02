class Presenter
  def self.attribute name
    define_method name do
      object.send name
    end
  end

  attr :object

  def initialize object
    @object = object
  end
end
