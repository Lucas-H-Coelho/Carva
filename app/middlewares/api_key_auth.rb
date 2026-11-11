# frozen_string_literal: true

class ApiKeyAuth
  def initialize(app)
    @app = app
  end

  def call(env)
    api_key = extract_api_key(env)

    if api_key.present?
      user = User.find_by(api_key: api_key)
      if user&.tenant&.status == 'active'
        env['current_user'] = user
        env['current_tenant'] = user.tenant
      end
    end

    @app.call(env)
  end

  private

  def extract_api_key(env)
    request = ActionDispatch::Request.new(env)
    request.headers['X-Carva-API-Key']
  end
end
