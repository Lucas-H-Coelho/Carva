# frozen_string_literal: true

class ApplicationController < ActionController::API
  include Pundit::Authorization

  before_action :authenticate_request

  private

  def authenticate_request
    token = request.headers['Authorization']&.delete_prefix('Bearer ')
    token ||= request.headers['X-Carva-API-Key']

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
    @current_user
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
