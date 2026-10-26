require 'etc'
require 'json'

abort 'Usage: ci-checkout <new-destination>' unless ARGV.length == 1
destination = File.expand_path(ARGV.fetch(0))
abort 'Destination must not exist' if File.exist?(destination) || File.symlink?(destination)
account = Etc.getpwnam('ci')
if Process.euid.zero?
  Process.groups = [account.gid]
  Process::GID.change_privilege(account.gid)
  Process::UID.change_privilege(account.uid)
end
abort 'Run as root or ci' unless Process.euid == account.uid
config = JSON.parse(File.read('/etc/ci/git-credentials.json'))
url = 'http://127.0.0.1/sre/ci/job-dsl-generator.git'
abort 'Unexpected repository URL' unless config.fetch('url') == url
environment = {
  'PATH' => '/opt/gitlab/embedded/bin:/usr/bin:/bin',
  'HOME' => account.dir,
  'LC_ALL' => 'C',
  'GIT_ASKPASS' => '/opt/ci/askpass.rb',
  'GIT_TERMINAL_PROMPT' => '0',
  'GIT_TRACE_CURL' => ENV.fetch('CAPTURE_TRACE_PATH'),
  'GIT_TRACE_CURL_NO_DATA' => '1',
  'GIT_CONFIG_NOSYSTEM' => '1',
  'GIT_CONFIG_GLOBAL' => '/dev/null'
}
exec(environment, '/opt/gitlab/embedded/bin/git', '-c', 'credential.helper=',
     '-c', "http.extraHeader=X-Request-ID:#{ENV.fetch('CAPTURE_REQUEST_ID')}", 'clone', '--quiet', '--no-hardlinks', url, destination, unsetenv_others: true)
