set :scm, :git
#set :deploy_via, :copy
set :scm_password, "bahbah"
set :rails_env, "production"

set :domain, "ask-economists.com"
set :application, "askeconn"
set :repository,  "root@72.14.179.64:/bah.git"
set :user, "root"
set :scm_verbose, true
default_run_options[:pty] = true

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