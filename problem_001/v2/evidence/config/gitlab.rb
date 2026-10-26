external_url 'http://127.0.0.1'
nginx['listen_addresses'] = ['127.0.0.1']
letsencrypt['enable'] = false
gitlab_rails['initial_root_password'] = File.read('/run/exercise/root-password').strip
gitlab_rails['initial_shared_runners_registration_token'] = 'isolated-exercise-no-runners'
gitlab_rails['gitlab_signup_enabled'] = false
gitlab_rails['smtp_enable'] = false
gitlab_rails['registry_enabled'] = false
registry['enable'] = false
prometheus_monitoring['enable'] = false
gitlab_kas['enable'] = false
gitlab_pages['enable'] = false
gitlab_rails['usage_ping_enabled'] = false
gitlab_rails['rack_attack_git_basic_auth'] = { 'enabled' => false }
puma['worker_processes'] = 0
puma['min_threads'] = 1
puma['max_threads'] = 4
sidekiq['max_concurrency'] = 5
postgresql['shared_buffers'] = '128MB'
