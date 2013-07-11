SERVICE_CONFIG = Yaml.load_file Rails.root.join('config', 'local-service.yml')

LocalService::Application.config.service do |service|
  service.type = SERVICE_CONFIG['type'].to_sym

  if service.type == :master
    # Master-Config goes here

  else
    # Slave-Config goes here
    service.location.key  = SERVICE_CONFIG['location']['key']
    service.location.name = SERVICE_CONFIG['location']['name']
    service.location.slug = SERVICE_CONFIG['location']['slug']

    service.master.url      = SERVICE_CONFIG['master']['url']
  end
end