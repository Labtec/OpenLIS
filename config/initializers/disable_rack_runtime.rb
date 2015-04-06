Rails.application.config.middleware.delete(Rack::Runtime) if Rails.env.production?
