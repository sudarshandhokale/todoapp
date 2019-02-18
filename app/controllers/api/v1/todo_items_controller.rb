class Api::V1::TodoItemsController < ApplicationController
  def create
    TodoItemService.create(params[:todo_list_id], todo_item_params) do |response|
      response.on_success(TodoItemSerializer) { |success| render(success) }
      response.on_validation_error { |error| render(error) }
      response.on_error { |error| render(error) }
    end
  end

  def update
    TodoItemService.update(params[:id], todo_item_params) do |response|
      response.on_success(TodoItemSerializer) { |success| render(success) }
      response.on_validation_error { |error| render(error) }
      response.on_error { |error| render(error) }
    end
  end

  def destroy
    TodoItemService.destroy(params[:id]) do |response|
      response.on_success(TodoListSerializer) { |success| render(success) }
      response.on_validation_error { |error| render(error) }
      response.on_error { |error| render(error) }
    end
  end

  def soft_delete
    TodoItemService.soft_delete(params[:id]) do |response|
      response.on_success(TodoListSerializer) { |success| render(success) }
      response.on_validation_error { |error| render(error) }
      response.on_error { |error| render(error) }
    end
  end

  def restore
    TodoItemService.restore(params[:id]) do |response|
      response.on_success(TodoListSerializer) { |success| render(success) }
      response.on_validation_error { |error| render(error) }
      response.on_error { |error| render(error) }
    end
  end

  private

  # Never trust parameters from the scary internet, only allow the white list through.
  def todo_item_params
    params.require(:todo_item).permit(:content)
  end
end
