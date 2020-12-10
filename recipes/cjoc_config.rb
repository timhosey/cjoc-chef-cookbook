# Copy config file
cookbook_file '/etc/default/cloudbees-core-oc' do
  source 'cloudbees-core-oc'
  owner 'root'
  group 'root'
  mode '0755'
  action :create
  notifies :restart, 'service[jenkins]', :immediately
end

# Does nothing unless triggered by the copy
service 'jenkins' do
  action :nothing
end
