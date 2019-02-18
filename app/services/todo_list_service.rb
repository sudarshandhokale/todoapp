class TodoListService < ApplicationService
  class << self
    def search(params, &block)
      todo_lists = params[:trash] ? TodoList.trash : TodoList.search(params[:title])
      meta = { total: todo_lists.count }
      todo_lists = todo_lists.pagination(params[:page], params[:limit])
      status ResponseStatus, :success, todo_lists, meta, &block
    rescue StandardError => e
      status ResponseStatus, :error, e, &block
    end

    def create(todo_list_params, &block)
      todo_list = TodoList.new(todo_list_params)
      if todo_list.save
        status ResponseStatus, :success, todo_list, &block
      else
        status ResponseStatus, :validation_error, todo_list.errors, &block
      end
    rescue StandardError => e
      status ResponseStatus, :error, e, &block
    end

    def update(id, todo_list_params, &block)
      todo_list = TodoList.find_by(id: id)
      if todo_list.update(todo_list_params)
        status ResponseStatus, :success, todo_list, &block
      else
        status ResponseStatus, :validation_error, todo_list.errors, &block
      end
    rescue StandardError => e
      status ResponseStatus, :error, e, &block
    end

    def destroy(id, &block)
      todo_list = TodoList.unscoped.find_by(id: id)
      todo_list.destroy
      status ResponseStatus, :success, :no_content, &block
    rescue StandardError => e
      status ResponseStatus, :error, e, &block
    end

    def soft_delete(id, &block)
      todo_list = TodoList.find_by(id: id)
      todo_list.soft_delete
      status ResponseStatus, :success, :no_content, &block
    rescue StandardError => e
      status ResponseStatus, :error, e, &block
    end

    def restore(id, &block)
      todo_list = TodoList.unscoped.find_by(id: id)
      todo_list.restore
      status ResponseStatus, :success, :no_content, &block
    rescue StandardError => e
      status ResponseStatus, :error, e, &block
    end
  end
end
