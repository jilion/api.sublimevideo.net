require 'sublime_video_private_api'
Dir[File.expand_path('../../app/models/**/*.rb', __dir__)].each do |file|
  require "#{File.dirname(file)}/#{File.basename(file, File.extname(file))}"
end
