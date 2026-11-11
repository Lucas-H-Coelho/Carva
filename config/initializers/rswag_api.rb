Rswag::Api.configure do |c|

  # Root folder where Swagger/OpenAPI files are located
  c.openapi_root = Rails.root.join('spec', 'openapi').to_s

  # Dynamically set the host for the API
  c.swagger_filter = lambda { |swagger, env|
    swagger['servers'] = [ { url: "https://#{env['HTTP_HOST']}/api/v1" } ]
  }
end
