class TodoListSerializer < ApplicationSerializer
  attributes :id, :title, :todo_items, :deleted_todo_items, :is_deleted

  def deleted_todo_items
    object.todo_items.unscope(where: :is_deleted).where(is_deleted: true)
  end
end
