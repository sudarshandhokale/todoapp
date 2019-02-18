class StandardErrorSerializer < ApplicationSerializer
  attributes :message, :exception, :trace

  def message
    'Sorry, something went wrong'
  end

  def resource
    object.try(:resource)
  end

  def exception
    resource.try(:message)
  end

  def trace
    resource.try(:backtrace)
  end
end
