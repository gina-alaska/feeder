config = YAML.load_file("config/default_url.yml")

Rails.application.routes.default_url_options[:host] = config[Rails.env]
