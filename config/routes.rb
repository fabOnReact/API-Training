=begin
require 'api_constraints'

MarketPlaceApi::Application.routes.draw do
  # Api definition
  namespace :api, defaults: { format: :json }, constraints: { subdomain: 'api' }, path: '/'  do
    scope module: :v1, constraints: ApiConstraints.new(version: 1, default: true) do
      resources :users, :only => [:show]
    end
  end

  devise_for :users
end
=end

Rails.application.routes.draw do
	namespace :api, defaults: { format: :json } do
		namespace :v1 do
			devise_for :users
			resources :users, :only => [:show, :create, :update]
		end
	end
end