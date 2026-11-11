# frozen_string_literal: true

# Serves the OpenAPI/Swagger YAML file for the Swagger UI.
class RswagUiController < ApplicationController
  skip_before_action :authenticate_request, raise: false

  def swagger_yaml
    file_path = Rails.root.join('spec', 'openapi', 'v1', 'swagger.yaml')
    send_file file_path, type: 'application/yaml', disposition: 'inline'
  end
end
