class ApplicationRecord < ActiveRecord::Base
  include SoftDeleteHandler
  self.abstract_class = true
end
