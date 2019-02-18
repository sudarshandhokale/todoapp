class Error
  include ActiveModel::Serializers::JSON
  attr_accessor :resource

  def initialize(resource = nil)
    @resource = resource
  end

  def self.model_name
    self
  end

  def attributes
    { resource: nil }
  end
end
