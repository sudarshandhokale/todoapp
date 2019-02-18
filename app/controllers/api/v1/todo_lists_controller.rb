class Api::V1::TodoListsController < ApplicationController
  def index
    TodoListService.search(params) do |response|
      response.on_success(TodoListSerializer) { |success| render(success) }
      response.on_validation_error { |error| render(error) }
      response.on_error { |error| render(error) }
    end
  end

  def create
    TodoListService.create(todo_list_params) do |response|
      response.on_success(TodoListSerializer) { |success| render(success) }
      response.on_validation_error { |error| render(error) }
      response.on_error { |error| render(error) }
    end
  end

  def update
    TodoListService.update(params[:id], todo_list_params) do |response|
      response.on_success(TodoListSerializer) { |success| render(success) }
      response.on_validation_error { |error| render(error) }
      response.on_error { |error| render(error) }
    end
  end

  def destroy
    TodoListService.destroy(params[:id]) do |response|
      response.on_success(TodoListSerializer) { |success| render(success) }
      response.on_validation_error { |error| render(error) }
      response.on_error { |error| render(error) }
    end
  end

  def soft_delete
    TodoListService.soft_delete(params[:id]) do |response|
      response.on_success(TodoListSerializer) { |success| render(success) }
      response.on_validation_error { |error| render(error) }
      response.on_error { |error| render(error) }
    end
  end

  def restore
    TodoListService.restore(params[:id]) do |response|
      response.on_success(TodoListSerializer) { |success| render(success) }
      response.on_validation_error { |error| render(error) }
      response.on_error { |error| render(error) }
    end
  end

  private

  # Never trust parameters from the scary internet, only allow the white list through.
  def todo_list_params
    params.require(:todo_list).permit(:title)
  end
end
