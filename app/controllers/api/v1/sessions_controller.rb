module Api
  module V1
    class SessionsController < ActionController::API
      # No before_action — handles auth inline

      def create
        user = User.find_by(email: params[:email])

        if user&.authenticate_devise?(params[:password])
          token = JWT.encode(
            { sub: user.id, iat: Time.current.to_i, exp: 7.days.from_now.to_i },
            Rails.application.secret_key_base,
            'HS256'
          )
          render json: { token: token }, status: :ok
        else
          render json: { error: 'Invalid credentials' }, status: :unauthorized
        end
      end

      def me
        user = current_user_from_token

        return render json: { error: 'Not authenticated' }, status: :unauthorized unless user

        render json: {
          user: {
            id: user.id,
            email: user.email,
            role: user.role,
            tenant: user.tenant&.subdomain
          }
        }
      end

      def destroy
        head :no_content
      end

      private

      def current_user_from_token
        token = request.headers['Authorization']&.delete_prefix('Bearer ')
        token ||= request.headers['X-Carva-API-Key']
        return nil unless token

        begin
          payload = JWT.decode(token, Rails.application.secret_key_base, true, algorithm: 'HS256').first
          User.find_by(id: payload['sub'])
        rescue JWT::DecodeError, JWT::ExpiredSignature
          nil
        end
      end
    end
  end
end
