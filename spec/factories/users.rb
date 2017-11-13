FactoryGirl.define do
  factory :user do
	email { FFaker::Internet.email }
	password '12345678'
	password_confirmation '12345678'    

	factory :user_with_products do 
		transient do 
			products_count 5
		end

		after(:create) do |user, evaluator|
			create_list(:product, evaluator.products_count, user: user)
		end
	end
  end
end
