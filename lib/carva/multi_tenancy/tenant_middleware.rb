module Carva
  module MultiTenancy
    class TenantMiddleware
      def initialize(app)
        @app = app
      end

      def call(env)
        request = ActionDispatch::Request.new(env)
        tenant = Carva::MultiTenancy::TenantResolver.new.resolve(request)
        Carva::Current.tenant = tenant
        @app.call(env)
      end
    end
  end
end
