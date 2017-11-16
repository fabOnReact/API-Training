Rails.application.routes.draw do
  mount SabisuRails::Engine => "/sabisu_rails"
	namespace :api, defaults: { format: :json } do
		namespace :v1 do
			resources :users, :only => [:show, :create, :update, :destroy] do
				resources :products, :only => [:create, :update, :destroy]
			end
	        resources :sessions, :only => [:create, :destroy]
	        resources :products, :only => [:show, :index]
			devise_for :users
		end
	end
end