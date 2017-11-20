require 'spec_helper'

describe Api::V1::ProductsController do
	describe 'GET #show' do
		before(:each) do 
			@product = FactoryGirl.create(:product)
			get :show, id: @product.id
		end

		it 'should show have a product title' do
			product_response = json_response[:product]
			expect(product_response[:title]).to eql(@product.title)
		end

		it 'should show have a product title' do
			product_response = json_response[:product]
			expect(product_response[:user][:email]).to eql(@product.user.email)
		end

		it { should respond_with 200 }
	end	

	describe 'GET #index' do 

		before(:each) do
			4.times { FactoryGirl.create(:product) }
		end

		context 'when is not receiving any product_ids parameter' do
			before(:each) do
				get :index
			end
			it 'should return four products' do 
				products_response = json_response[:products]
				expect(products_response).to have(4).items
			end

			it 'should have the user object in each product' do
				products_response = json_response[:products]
				products_response.each do |product_response|
					expect(product_response[:user]).to be_present
				end
			end

			it { should respond_with 200 }
		end

		context 'when is receving the product_ids parameter' do
			before(:each) do
				@user = FactoryGirl.create(:user)
				4.times { FactoryGirl.create(:product, user: @user)}
				get :index, product_ids: @user.product_ids
			end

			it 'return just the products that belong to the user' do
				products_response = json_response[:products]
				products_response.each do |product_response|
					expect(product_response[:user][:email]).to eql(@user.email)
				end
			end
		end
	end

	describe 'POST #create' do
		context 'when is successfully created' do
			before(:each) do
				user = FactoryGirl.create(:user)
				@product_attributes = FactoryGirl.attributes_for(:product)
				api_authorization_header user.auth_token
				post :create, { user_id: user.id, product: @product_attributes }
			end

			it 'renders a json representation for the product just created' do
				expect(json_response[:product][:title]).to eql(@product_attributes[:title])
			end

			it { should respond_with(201) }
		end

		context 'when is not created' do
			before(:each) do
				user = FactoryGirl.create(:user)
				@invalid_attributes = { title: 'Some title', price: 'A string'}
				api_authorization_header(user.auth_token)
				post :create, { user_id: user.id, product: @invalid_attributes }
			end

			it 'should include an error in the response' do
				product_response = json_response
				expect(product_response).to have_key(:errors)
			end

			it 'should include a description of the error' do
				product_response = json_response
				expect(product_response[:errors][:price]).to include('is not a number')
			end

			it { should respond_with 422 }
		end
	end

	describe 'PATCH #update' do
		before(:each) do
			@user = FactoryGirl.create(:user)
			@product = FactoryGirl.create(:product, user: @user)
			api_authorization_header(@user.auth_token)
		end
		
		context 'when is successfully updated' do
			before(:each) do
				patch :update, { user_id: @user.id, id: @product.id, product: { title: 'A new title' } }
			end

			it 'should return the product updated in json format' do 
				product_response = json_response[:product]
				expect(product_response[:title]).to eql('A new title')
			end

			it { should respond_with 200 }
		end

		context 'when is not successfully updated' do
			before(:each) do
				patch :update, { user_id: @user.id, id: @product.id, product: {price: 'A string instead of a number'}}
			end

			it 'should return a json including the errors key' do
				product_response = json_response
				expect(product_response).to have_key(:errors)
			end

			it 'should include a message explaining the problem' do
				product_response = json_response
				expect(product_response[:errors][:price]).to include('is not a number')
			end

			it { should respond_with 422 }
		end
	end

	describe 'DELETE #destroy' do
		before(:each) do
			user = FactoryGirl.create(:user)
			product = FactoryGirl.create(:product, user: user)
			api_authorization_header(user.auth_token)
			delete :destroy, { user_id: user.id, id: product.id }
		end

		it { should respond_with 204 }
	end
end
