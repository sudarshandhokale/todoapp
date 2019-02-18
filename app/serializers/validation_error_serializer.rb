class ValidationErrorSerializer < ApplicationSerializer
  attributes :errors, :message

  def resource
    object.try(:resource)
  end

  def errors
    error_json = {}
    return error_json if resource.blank?
    resource.to_hash(true).map do |k, v|
      v.map do |msg|
        error_json[k] = msg
      end
    end
    error_json
  end

  def message
    errors.values.join(', ')
  end
end
