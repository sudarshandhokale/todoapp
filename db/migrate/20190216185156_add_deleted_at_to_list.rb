class AddDeletedAtToList < ActiveRecord::Migration[5.2]
  def change
  	add_column :todo_lists, :is_deleted, :boolean, default: false
  	add_column :todo_items, :is_deleted, :boolean, default: false
  end
end
