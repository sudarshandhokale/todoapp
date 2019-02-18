class ApplicationService
  def self.status(klass, status, object = nil, meta = {}, &block)
    yield klass.send(status, object, meta) if block_given?
    print_error(object) if status.to_s.eql?('error')
    object
  end

  def self.print_error(object)
    puts "Error ===> #{object.message}\n#{object.backtrace}"
  end
end
