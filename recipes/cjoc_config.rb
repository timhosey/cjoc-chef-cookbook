# Copy config file
cookbook_file '/etc/default/cloudbees-core-oc' do
  source 'cloudbees-core-oc'
  owner 'root'
  group 'root'
  mode '0755'
  action :create
  notifies :reload, 'service[cloudbees-core-oc]', :immediately
  notifies :restart, 'service[cloudbees-core-oc]', :immediately
end

# Does nothing unless triggered by the copy
service 'cloudbees-core-oc' do
  action :nothing
  reload_command 'systemctl daemon-reload'
end
