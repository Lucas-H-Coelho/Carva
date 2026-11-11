# frozen_string_literal: true

class ApplicationController < ActionController::API
  include Pundit::Authorization

  before_action :authenticate_request

  private

  def authenticate_request
    # 1. Check middleware-injected current_user (API Key auth)
    @current_user = read_current_user_from_env

    return if @current_user && @current_user.tenant&.status == 'active'

    # 2. JWT auth (fallback)
    token = request.headers['Authorization']&.delete_prefix('Bearer ')
    return render_json_error('Unauthorized', 401) unless token

    begin
      payload = JWT.decode(token, Rails.application.secret_key_base, true, algorithm: 'HS256').first
      @current_user = User.find_by(id: payload['sub'])
    rescue JWT::DecodeError, JWT::ExpiredSignature
      return render_json_error('Unauthorized', 401)
    end

    return render_json_error('Forbidden', 403) unless @current_user&.tenant&.status == 'active'
  end

  def current_user
    @current_user ||= read_current_user_from_env
  end

  def read_current_user_from_env
    return nil unless request.respond_to?(:env)
    request.env['current_user']
  end

  def current_tenant
    @current_tenant ||= current_user&.tenant
  end

  def require_owner
    return render_json_error('Unauthorized', 401) unless current_user
    return if current_user&.role == 'owner'

    render_json_error('Forbidden', 403, detail: 'Owner access required')
  end

  def require_shift_lead_or_owner
    return render_json_error('Unauthorized', 401) unless current_user
    return if current_user&.role == 'owner' || current_user&.role == 'shift_lead'

    render_json_error('Forbidden', 403, detail: 'Shift lead or owner access required')
  end

  def render_json_error(title, status, detail: nil, pointer: nil)
    error_hash = {
      status: status,
      title: title,
      detail: detail || title
    }
    error_hash[:source] = { pointer: pointer } if pointer

    render json: { errors: [error_hash] }, status: status
  end

  def render_json_api(resource, status: :ok)
    render json: {
      data: serialize_resource(resource),
      meta: { version: 'v1' }
    }, status: status
  end

  def render_json_api_collection(resources, status: :ok)
    render json: {
      data: resources.map { |r| serialize_resource(r) },
      meta: {
        version: 'v1',
        page: {
          current: params[:page] || 1,
          total: resources.respond_to?(:total_pages) ? resources.total_pages : 1,
          per_page: params[:per_page] || 25
        }
      }
    }, status: status
  end

  private

  def serialize_resource(resource)
    {
      id: resource.id,
      type: resource.class.model_name.to_s.underscore,
      attributes: resource.as_json(except: %i[created_at updated_at])
    }
  end
end
