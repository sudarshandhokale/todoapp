class ResponseStatus
  attr_reader :status, :resources, :meta

  class << self
    def method_missing(method_name, *args)
      new(method_name.to_sym, *args)
    end
  end
  
  def initialize(status, resources = nil, meta = {})
    @status = status
    @resources = resources
    @meta = meta
  end

  def method_missing(method_name, *args)
    return unless method_name.to_s.include?('on_')
    method_status = method_name.to_s.sub('on_', '').to_sym
    return unless status.eql?(method_status)
    yield send("render_#{method_status}", *args)
  end

  def render_success(serializer = nil)
    return render_null if resources.blank?
    {
      json: resources,
      each_serializer: serializer,
      meta: meta.values[0],
      meta_key: meta.keys[0],
      status: :ok
    }
  end

  def render_null
    {
      json: :no_data_found,
      status: :ok
    }
  end

  def render_error
    {
      json: Error.new(resources),
      serializer: StandardErrorSerializer,
      status: 500
    }
  end

  def render_validation_error
    {
      json: Error.new(resources),
      serializer: ValidationErrorSerializer,
      status: 422
    }
  end
end
