require 'yaml'

config_file = Rails.root.join('config', 'local-service.yml')

if File.exists? config_file
  SERVICE_CONFIG = YAML.load_file config_file

  LocalService::Application.configure do
    config.service = ActiveSupport::OrderedOptions.new
    config.service.type = SERVICE_CONFIG['type'].to_sym

    if config.service.type == :master
      # Master-Config goes here
    else
      # Slave-Config goes here
      config.service.location_key  = SERVICE_CONFIG['location']['key']
      config.service.location_name = SERVICE_CONFIG['location']['name']
      config.service.location_slug = SERVICE_CONFIG['location']['slug']

      config.service.master_url      = SERVICE_CONFIG['master']['url']
    end
  end
end