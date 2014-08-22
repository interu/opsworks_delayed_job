# Adapted from unicorn::rails: https://github.com/aws/opsworks-cookbooks/blob/master/unicorn/recipes/rails.rb

include_recipe "opsworks_delayed_job::service"

# setup delayed_job service per app
node[:deploy].each do |application, deploy|

  # Allow deploy user to restart workers
  template "/etc/sudoers.d/#{deploy[:user]}" do
    mode 0440
    source "sudoer.erb"
    variables :user => deploy[:user]
  end

  template "#{node[:monit][:includes_dir]}/delayed_job_#{application}.monitrc" do
    mode 0644
    source "delayed_job.monitrc.erb"
    variables(:deploy => deploy, :application => application, :delayed_job => node[:delayed_job][application])

    notifies :reload, resources(:service => "monit"), :immediately
  end

end
