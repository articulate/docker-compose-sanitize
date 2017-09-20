require 'json'
require 'yaml'

UNIVERSAL_OPTIONS = ["volumes"]
sanitize_options = Hash.new {|h,k| h[k]=[]}

CONFIG_FILE = './docker-compose.yml'

config = YAML.load_file(CONFIG_FILE)

config['services'].each do |k, v|
  UNIVERSAL_OPTIONS.each do |x|
    sanitize_options[k] << x
  end
end

if File.exists?('./service.json')
  service_json = JSON.parse(File.read('./service.json'))
  if service_json.has_key?("sanitize")
    service_json["sanitize"].each do |k, v|
      v.each do |z|
        sanitize_options[k] << z
      end
    end
  end
else
  puts "No service.json file detected"
end

puts 'Sanitizing service options...'

sanitize_options.each do |service, options|
  options.each do |option|
    puts "stripping #{option} option from #{service} container"
    config["services"][service].delete(option)
  end
end

File.write(CONFIG_FILE, config.to_yaml)

puts 'done.'