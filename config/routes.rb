Rails.application.routes.draw do
  mount SabisuRails::Engine => "/sabisu_rails"
	namespace :api, defaults: { format: :json } do
		namespace :v1 do
			resources :users, :only => [:show, :create, :update, :destroy]
      resources :sessions, :only => [:create, :destroy]
			devise_for :users
		end
	end
end