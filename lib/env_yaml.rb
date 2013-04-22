require 'yaml'
begin
  env_yaml = YAML.load_file(File.expand_path('../config/env.yml', __dir__))
  if env_hash = env_yaml[ENV['RACK_ENV'] || 'development']
    env_hash.each_pair do |k,v|
      ENV[k] = v.to_s
    end
  end
rescue StandardError => e
end
