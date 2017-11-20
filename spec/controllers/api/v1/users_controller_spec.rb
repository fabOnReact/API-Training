require 'spec_helper'
require 'api/v1/users_controller'

describe Api::V1::UsersController do
	describe 'GET #show' do
		before(:each) do
			@user = FactoryGirl.create :user
			get :show, id: @user.id
		end

		it 'responds with a json object that includes the user email' do
			user_response = json_response[:user]
			expect(user_response[:email]).to eq(@user.email)
		end

		it { should respond_with 200}
	end

	describe 'POST #create' do
		context 'when it is sucessfully created' do
			before(:each) do
				@valid_attributes = FactoryGirl.attributes_for :user
				post :create, { user: @valid_attributes }
			end

			it 'creates the user' do
				user_response = json_response[:user]
				expect(user_response[:email]).to eq(@valid_attributes[:email])
			end

			it { should respond_with 201 }
		end

		context 'when it is not created' do
			before(:each) do
				@invalid_attributes = { password: '123456', password_confirmation: '123456'}
				post :create, { user: @invalid_attributes}
			end

			it 'does not create the user' do
				user_response = json_response
				expect(user_response).to have_key(:errors)
			end

			it 'renders the json error' do
				user_response = json_response
				expect(user_response[:errors][:email]).to include "can't be blank"
			end

			it { should respond_with 422 }
		end
 	end

 	describe 'PUT #update' do
 		context 'when it is sucessfully updated' do
 			before(:each) do
 				@user = FactoryGirl.create(:user)
 				api_authorization_header(@user.auth_token)
 				patch :update, { id: @user.id, user: { email: 'newemail@example.com' }}
 			end

 			it 'updates the user' do
 				user_response = json_response[:user]
 				expect(user_response[:email]).to eq('newemail@example.com')
 			end

 			it { should respond_with 200}

 		end

 		context 'when it is not sucessfully updated' do
 			before(:each) do
 				@user = FactoryGirl.create(:user)
 				api_authorization_header(@user.auth_token)
 				patch :update, {id: @user.id, user: { email: 'invalidemail.com'}}
 			end

 			it 'does not update the user' do
 				user_response = json_response
 				expect(user_response).to have_key(:errors)
 			end

 			it 'does include error description' do
 				user_response = json_response
 				expect(user_response[:errors][:email]).to include 'is invalid'
 			end

 			it { should respond_with 422 }
 		end
 	end

 	describe 'DELETE #destroy' do
 		before(:each) do 
 			@user = FactoryGirl.create(:user)
 			api_authorization_header(@user.auth_token)
 			delete :destroy, id: @user.id
 		end

 		it { should respond_with 204}
 	end
end