set :scm, :git
#set :deploy_via, :copy
set :scm_password, "E/8uC$Vr!y{,xk"
set :rails_env, "production"

set :domain, "ask-economists.com"
set :application, "askeconn"
set :repository,  "deploy@72.14.179.64:/home/deploy/askeconn.git"
set :user, "deploy"

# If you aren't deploying to /u/apps/#{application} on the target
# servers (which is the default), you can specify the actual location
# via the :deploy_to variable:
set :deploy_to, "/var/www/askeconn"

# If you aren't using Subversion to manage your source code, specify
# your SCM below:
# set :scm, :subversion

role :app, domain
role :web, domain
role :db,  domain, :primary => true

namespace :deploy do
  
  desc "Restarting mod_rails with restart.txt"
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "touch #{current_path}/tmp/restart.txt"
  end
  
  [:start, :stop].each do |t|
    desc "#{t} task is a no-op with mod_rails"
    task t, :roles => :app do ; end
  end

end