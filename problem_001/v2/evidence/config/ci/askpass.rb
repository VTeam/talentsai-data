#!/opt/gitlab/embedded/bin/ruby
require 'json'

config = JSON.parse(File.read('/etc/ci/git-credentials.json'))
prompt = ARGV.fetch(0, '')
if prompt.include?('Username')
  puts config.fetch('username')
elsif prompt.include?('Password')
  puts config.fetch('token')
else
  exit 1
end
