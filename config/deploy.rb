set :application, 'puffin-feeder'
set :repo_url, 'https://github.com/gina-alaska/feeder.git'

ask :branch, proc { `git rev-parse --abbrev-ref HEAD`.chomp }

set :deploy_to, '/www/puffin'
set :scm, :git

set :format, :pretty
set :log_level, :debug
# set :pty, true

set :linked_files, %w{config/database.yml config/sunspot.yml config/sidekiq.yml}
set :linked_dirs, %w{bin log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system}

# set :default_env, { path: "/opt/ruby/bin:$PATH" }
set :keep_releases, 5

set :rails_env, :production
# set :unicorn_binary, "/usr/bin/unicorn"
set :unicorn_config, "/etc/unicorn/puffin.rb"
set :unicorn_pid, "#{current_path}/tmp/pids/unicorn.pid"
 
namespace :deploy do

  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      # Your restart mechanism here, for example:
      # execute :touch, release_path.join('tmp/restart.txt')
      # execute :kill, '-USR2', "`cat #{release_path.join('tmp/pids/unicorn.pid')}`"
    end
  end

  after :restart, :clear_cache do
    on roles(:web), in: :groups, limit: 3, wait: 10 do
      # Here we can do anything such as:
      # within release_path do
      #   execute :rake, 'cache:clear'
      # end
    end
  end

  after :finishing, 'deploy:cleanup'

end
