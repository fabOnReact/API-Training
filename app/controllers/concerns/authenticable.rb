module Authenticable
	def current_user
		@user ||= User.find_by(auth_token: request.headers['Authorization'])
	end

	def authenticate_with_token!
		render json: { errors: 'Not Authenticated' }, status: :unauthorized unless user_signed_in?
	end

	def user_signed_in?
		current_user.present?
	end
end