RSpec.describe Api::V1::TodoItemsController, type: :controller  do
	context 'POST #create' do
		it 'creates new todo_items' do
    expect(FactoryBot.create(:todo_item)).to be_valid 
		end
	end

	context 'PATCH #update' do
		it 'updates todo_items' do
			@todo_item = TodoItem.last
			patch :update, params: {:id => @todo_item.id, :todo_item => {content: "wheat"} }
			expect(response).not_to be_redirect
		end
	end

	context 'DELETE #destroy' do
		it 'deletes todo_items' do
			@todo_item = TodoItem.last
			expect{ 
        delete :destroy, params: { :id => @todo_item.id } }.to change(TodoItem, :count).by(-1)
		end
	end

	context 'DELETE #soft_delete' do
		it 'soft deletes todo_list' do
			@todo_item = TodoItem.last
			expect{ 
        delete :soft_delete, params: { :id => @todo_item.id } }
      response.should be_success
		end
	end

	context 'PATCH #restore' do
		it 'updates todo_items' do
			@todo_item = TodoItem.last
			patch :restore, params: { :id => @todo_item.id }
			expect(response).not_to be_redirect
		end
	end
end
