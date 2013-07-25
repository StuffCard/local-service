require 'yaml'

config_file = Rails.root.join('config', 'local-service.yml')

if File.exists? config_file
  SERVICE_CONFIG = YAML.load_file(config_file)[Rails.env]

  LocalService::Application.configure do
    config.service = ActiveSupport::OrderedOptions.new
    config.service.type = SERVICE_CONFIG['type'].to_sym
    config.service.location = {
      key: SERVICE_CONFIG['location']['key'],
      name: SERVICE_CONFIG['location']['name']
    }

    if config.service.type == :master
      # Master-Config goes here
      config.service.master = ActiveSupport::OrderedOptions.new
      SERVICE_CONFIG['locations'].each do |key, ip|
        config.service.master.ips = ActiveSupport::OrderedOptions.new if config.service.master.ips == nil
        config.service.master.ips[key] = ip
      end
    else
      # Slave-Config goes here
      config.service.master = {
        sync: SERVICE_CONFIG['master']['sync'],
        socket: SERVICE_CONFIG['master']['socket']
      }
    end
  end
end