# Copy config file
cookbook_file '/etc/default/cloudbees-core-cm' do
  source 'cloudbees-core-cm'
  owner 'root'
  group 'root'
  mode '0755'
  action :create
  notifies :reload, 'service[cloudbees-core-cm]', :immediately
  notifies :restart, 'service[cloudbees-core-cm]', :immediately
end

# Does nothing unless triggered by the copy
service 'cloudbees-core-cm' do
  action :nothing
  reload_command 'systemctl daemon-reload'
end
