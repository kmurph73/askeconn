set :stage, "staging" unless variables[:stage]

stages =  %w(staging production)
set :default_stage, "staging"
require 'capistrano/ext/multistage'

location = fetch(:stage_dir, "config/deploy")
load "#{location}/#{stage}"

default_run_options[:pty] = true
set :application, "askeconn_#{stage}"
set :domain, "72.14.179.64"
set :repository,  "deploy@72.14.179.64:~/askeconn.git"

set :mongrel_conf, "#{current_path}/config/mongrel_cluster.yml"
set :scm, :git
#set :deploy_via, :copy
set :scm_password, "password"
set :branch, "master"

ssh_options[:paranoid] = false

set :user, "deploy"
set :runner, user

role :app, domain
role :web, domain
role :db,  domain, :primary => true

task :update_config, :roles => [:app] do
  run "cp -Rf #{shared_path}/config/* #{release_path}/config/"
  #run "ln -s #{shared_path}/log #{release_path}/log"
end

after "deploy:update_code", :update_config

namespace :passenger do
  desc "Restart Application"
  task :restart do
    run "touch #{current_path}/tmp/restart.txt"
  end
end

after :deploy, "passenger:restart"