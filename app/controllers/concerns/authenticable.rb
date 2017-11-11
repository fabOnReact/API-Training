module Authenticable
	def current_user
		@user ||= User.find_by(auth_token: request.headers['Authorization'])
	end

	def authenticate_with_token!
		render json: { errors: 'Not Authenticated' }, status: :unauthorized unless current_user.present?
	end
end