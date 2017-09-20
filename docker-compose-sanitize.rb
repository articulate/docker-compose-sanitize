require 'json'
require 'yaml'

UNIVERSAL_OPTIONS = ["volumes"]
sanitize_options = Hash.new {|h,k| h[k]=[]}

CONFIG_FILE = './docker-compose.yml'

config = YAML.load_file(CONFIG_FILE)

config['services'].each do |k, v|
  universal_options.each do |x|
    sanitize_options[k] << x
  end
end

if File.exists?('./service.json')
  JSON.parse(File.read('./service.json'))["sanitize"].each do |k, v|
    v.each do |z|
      sanitize_options[k] << z
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