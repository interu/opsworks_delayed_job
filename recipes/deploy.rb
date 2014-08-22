# Adapted from deploy::rails: https://github.com/aws/opsworks-cookbooks/blob/master/deploy/recipes/rails.rb

node[:deploy].each do |application, deploy|

  include_recipe "opsworks_delayed_job::setup"
  
  execute "start delayed_jobs for app #{application}" do
    Chef::Log.debug("COMMAND TO RUN #{node[:delayed_job][application][:restart_command]}")
    node[:delayed_job][application][:restart_command]
  end
end
