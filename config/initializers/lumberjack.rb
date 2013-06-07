require 'lumberjack'
$logger = Lumberjack::Logger.new("log/#{ENV['RACK_ENV']}.log") # Open a new log file with INFO level
