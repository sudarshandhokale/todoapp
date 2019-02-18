class TodoItem < ApplicationRecord
  belongs_to :todo_list
  validates :content, presence: true, length: { maximum: 60 }
end
