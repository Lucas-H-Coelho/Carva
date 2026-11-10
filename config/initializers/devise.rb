# frozen_string_literal: true

Devise.setup do |config|
  config.secret_key = Rails.application.secret_key_base
end

# Skip JWT authentication for session routes — SessionsController handles
# auth inline via its own `current_user` private method.
Warden::JWTAuth.configure do |jwt_config|
  jwt_config.dispatch_requests.reject! do |method, path_regexp|
    path_regexp.match?('/api/v1/session')
  end
end
