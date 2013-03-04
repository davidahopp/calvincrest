require "rvm/capistrano"
require "bundler/capistrano"

set :application, "calvincrest"
set :repository,  "https://github.com/davidahopp/calvincrest.git"
set :scm, :git
set :branch, 'master'
set :deploy_via, :remote_cache
ssh_options[:forward_agent] = true
set :keep_releases, 3

set :deploy_to, "/srv/www/apps/calvincrest"

set :bundle_dir, ''
set :bundle_flags, '--quiet'

server "calvincrest.davidahopp.com", :app, :web, :db, :primary => true

set :use_sudo, false
set :user, 'sitedeploy'
ssh_options[:keys] = ["/home/vagrant/.ssh/calvincrest.pem"]

# Add RVM's lib directory to the load path.
#$:.unshift(File.expand_path('./lib', ENV['rvm_path']))

set :rvm_ruby_string, '1.9.3'
set :rvm_type, :system
set :bundle_without,  [:development, :test]

# if you want to clean up old releases on each deploy uncomment this:
# after "deploy:restart", "deploy:cleanup"

# if you're still using the script/reaper helper you will need
# these http://github.com/rails/irs_process_scripts

# If you are using Passenger mod_rails uncomment this:
namespace :deploy do
  task :start do ; end
  task :stop do ; end

  task :restart, :roles => :app, :except => { :no_release => true } do
    run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
  end
end


namespace :db do

  task :setup do
    run "ln -sf #{shared_path}/database.yml #{release_path}/config/"
  end

  task :migrate do
    run "cd #{release_path} && bundle exec rake RAILS_ENV=production db:migrate"
  end

  task :rollback do
    if previous_release
      run "cd #{current_path} && bundle exec rake RAILS_ENV=production db:migrate VERSION=`cat #{previous_release}/migration_version.txt`"
    end
  end

  task :set_version do
    run "cd #{release_path} && bundle exec rake RAILS_ENV=production db:current_version > migration_version.txt"
  end

  #
  #before :deploy do
  #  # Get the topmost migration that has been run:
  #  run "rake db:current_version > migration_version.txt"
  #end
  #
  #after 'deploy:rollback' do
  #  run "rake db:migrate VERSION=`cat migration_version.txt`"
  #end
  #
  #after :deploy do
  #  # Clean up now that we don't need it....
  #  run "unlink migration_version.txt"
  #end

end

after "bundle:install", "db:setup"
after "db:setup", "db:migrate"
after "db:migrate", "db:set_version"
after "deploy:restart", "deploy:cleanup"

before "deploy:rollback", "db:rollback"
after "deploy:rollback:revision", "bundle:install"

#namespace :deploy do
#  desc "Restarting mod_rails with restart.txt"
#  task :restart, :roles => :app, :except => { :no_release => true } do
#    run "touch #{current_path}/tmp/restart.txt"
#  end
#
#  [:start, :stop].each do |t|
#    desc "#{t} task is a no-op with mod_rails"
#    task t, :roles => :app do ; end
#  end
#end