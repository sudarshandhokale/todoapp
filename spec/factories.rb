FactoryBot.define do
  factory :todo_list do
    title {"Trip Plan"}
  end

  factory :todo_item do
  	association :todo_list
    content {"Buy Tickets"}
  end
  
end
