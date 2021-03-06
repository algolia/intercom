require "bundler/capistrano"

set :default_environment, {
  'GIT_SSH' => '/home/prod/ssh-intercom.sh'
}

default_run_options[:pty] = true 

# servers
server 'www1.algolia.com', :app, :web, :db, :cron, primary: true

# application
set :application, "Intercom by Algolia"
set :deploy_to, "/var/www/intercom"
set :user, "prod"
set :use_sudo, false

# repository
set :local_repository, "."
set :repository, "git@github.com:algolia/intercom.git"
set :scm, :git
set :deploy_via, :remote_cache
set :branch, "master"
set :git_shallow_clone, 1

# keep 5 last releases
set :keep_releases, 5
after "deploy:update", "deploy:cleanup"

# configuration
desc "Copy in server specific configuration files" 
task :copy_shared do
  run "cp #{deploy_to}/shared/config/application.yml #{release_path}/config/"
end
before "bundle:install", "copy_shared"

desc "Restart Thin"
namespace :deploy do
  task :restart do
    run "cd #{current_path} && bundle exec thin restart -C #{deploy_to}/shared/thin.yml"
  end
end

# ugly workaround for bug https://github.com/capistrano/capistrano/issues/81
before "deploy:assets:precompile", "bundle:install"

# rvm
require "rvm/capistrano"
set :rvm_ruby_string, 'ruby-2.0.0-p353'

# cron
set :whenever_command, "bundle exec whenever"
set :whenever_roles, [:cron]
require "whenever/capistrano"
