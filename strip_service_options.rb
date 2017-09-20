require 'yaml'

CONFIG_FILE = './docker-compose.yml'

puts 'Sanitizing service options...'

config = YAML.load_file(CONFIG_FILE)
config['services'] = config['services'].each_with_object({}) do |(key, value), memo|
  memo[key] = value.reject do |k, v|
    strip_option = ARGV.include?(k)
    puts "stripping #{k} option from #{key} container" if strip_option
    strip_option
  end
end

File.write(CONFIG_FILE, config.to_yaml)

puts 'done.'
