require 'yaml'

SERVICE_CONFIG = YAML.load_file Rails.root.join('config', 'local-service.yml')

LocalService::Application.config do |config|
  config.service.type = SERVICE_CONFIG['type'].to_sym

  if config.service.type == :master
    # Master-Config goes here

  else
    # Slave-Config goes here
    config.service.location.key  = SERVICE_CONFIG['location']['key']
    config.service.location.name = SERVICE_CONFIG['location']['name']
    config.service.location.slug = SERVICE_CONFIG['location']['slug']

    config.service.master.url      = SERVICE_CONFIG['master']['url']
  end
end