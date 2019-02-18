class TodoItem < ApplicationRecord
  belongs_to :todo_list
  validates :content, presence: true, length: { maximum: 60 }, format: { with: /\A[a-zA-Z\d ]+\z/ }
end
