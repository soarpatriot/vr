# config valid only for current version of Capistrano
lock '3.5.0'

set :application, 'vr'
set :repo_url, 'git@github.com:soarpatriot/vr.git'

# Default branch is :master
# ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp

# Default deploy_to directory is /var/www/my_app_name
# set :deploy_to, '/var/www/my_app_name'

# Default value for :scm is :git
set :scm, :git

# Default value for :format is :airbrussh.
# set :format, :airbrussh

# You can configure the Airbrussh format using :format_options.
# These are the defaults.
# set :format_options, command_output: true, log_file: 'log/capistrano.log', color: :auto, truncate: :auto

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
set :linked_files, fetch(:linked_files, []).push('config/prod.secret.exs','config/prod.exs', 'docker-compose.yml')

# Default value for linked_dirs is []
# rel _build
set :linked_dirs, fetch(:linked_dirs, [])
  .push('deps', 'node_modules', 'log', '_build')

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for keep_releases is 5
set :mix_env, 'prod'
set :keep_releases, 5
# set :phoenix_mix_env -> 'prod' #default fetch(:mix_env)
 #&& MIX_ENV=#{fetch(:mix_env)} mix phoenix.digest && MIX_ENV=#{fetch(:mix_env)} mix ompile && MIX_ENV=#{fetch(:mix_env)} mix release"
set :install_commands, "cd current\
        && MIX_ENV=#{fetch(:mix_env)} mix local.hex --force\
        && MIX_ENV=#{fetch(:mix_env)} mix local.rebar --force\
        && MIX_ENV=#{fetch(:mix_env)} mix hex.repo set hexpm --url https://hexpm.upyun.com\
        && MIX_ENV=#{fetch(:mix_env)} mix deps.get --only prod"
set :commands, "cd current\ 
        && MIX_ENV=#{fetch(:mix_env)} mix local.hex --force\
        && MIX_ENV=#{fetch(:mix_env)} mix local.rebar --force\
        && MIX_ENV=#{fetch(:mix_env)} mix hex.repo set hexpm --url https://hexpm.upyun.com\
        && MIX_ENV=#{fetch(:mix_env)} mix deps.get --only prod\
        && npm install\
        && ./node_modules/brunch/bin/brunch build --production\
        && MIX_ENV=#{fetch(:mix_env)} mix ecto.create && MIX_ENV=#{fetch(:mix_env)} mix ecto.migrate\
        && MIX_ENV=#{fetch(:mix_env)} mix phoenix.digest && MIX_ENV=#{fetch(:mix_env)} iex -S mix phoenix.server"
namespace :deploy do
  task :build do
    on roles(:all), in: :sequence do
      within current_path  do
      end
    end
  end
 
  desc 'restart phoenix app'
  task :restart do
    invoke 'deploy:stop' 
    invoke 'deploy:start' 
  end
  task :start do 
    on roles(:all), in: :sequence do
      within current_path  do
        execute :"docker-compose", "up -d"
      end
    end

  end
  task :stop do 
    on roles(:all), in: :sequence do
      within current_path  do
        execute :"docker-compose", "down"
      end
    end
  end
  task :chown do 
    on roles(:all), in: :sequence do
      execute :echo, "start && sudo chown -R -v #{fetch(:user)}:#{fetch(:user)} #{fetch(:deploy_to)}/shared"
    end
  end
  after :check, "docker:upload_compose"
  # after :publishing, "deploy:chown"
  after :published, "restart"
end
