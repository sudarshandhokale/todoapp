RSpec.describe Api::V1::TodoListsController, type: :controller  do
	context 'GET #index' do
		it 'returns a success response' do
			get :index
			expect(response).to be_success
		end
	end

	context 'POST #create' do
		it 'creates new todo_list' do
    expect(FactoryBot.create(:todo_list)).to be_valid 
		end
	end

	context 'PATCH #update' do
		it 'updates todo_list' do
			@todo_list = TodoList.last
			patch :update, params: {:id => @todo_list.id, :todo_list => {title: "Dairy"} }
			expect(response).not_to be_redirect
		end
	end

	context 'DELETE #soft_delete' do
		it 'soft deletes todo_list' do
			@todo_list = TodoList.last
			expect{ 
        delete :soft_delete, params: { :id => @todo_list.id } }
      response.should be_success
		end
	end

	context 'PATCH #restore' do
		it 'restore todo_list' do
			@todo_list = TodoList.last
			patch :restore, params: {:id => @todo_list.id }
			expect(response).not_to be_redirect
		end
	end
end
