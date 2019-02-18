class TodoItemService < ApplicationService
  class << self
    def create(todo_list_id, todo_item_params, &block)
      todo_list = TodoList.find_by(id: todo_list_id)
      todo_item = todo_list.todo_items.new(todo_item_params)
      if todo_item.save
        status ResponseStatus, :success, todo_item, &block
      else
        status ResponseStatus, :validation_error, todo_item.errors, &block
      end
    rescue StandardError => e
      status ResponseStatus, :error, e, &block
    end

    def update(id, todo_item_params, &block)
      todo_item = TodoItem.find_by(id: id)
      if todo_item.update(todo_item_params)
        status ResponseStatus, :success, todo_item, &block
      else
        status ResponseStatus, :validation_error, todo_item.errors, &block
      end
    rescue StandardError => e
      status ResponseStatus, :error, e, &block
    end

    def destroy(id, &block)
      todo_item = TodoItem.unscoped.find_by(id: id)
      todo_item.destroy
      status ResponseStatus, :success, :no_content, &block
    rescue StandardError => e
      status ResponseStatus, :error, e, &block
    end

    def soft_delete(id, &block)
      todo_item = TodoItem.find_by(id: id)
      todo_item.soft_delete
      status ResponseStatus, :success, :no_content, &block
    rescue StandardError => e
      status ResponseStatus, :error, e, &block
    end

    def restore(id, &block)
      todo_item = TodoItem.unscoped.find_by(id: id)
      todo_item.restore
      status ResponseStatus, :success, :no_content, &block
    rescue StandardError => e
      status ResponseStatus, :error, e, &block
    end
  end
end
