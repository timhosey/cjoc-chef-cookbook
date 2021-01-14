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

# Copy CasC files; make dir if it doesn't exist
directory '/etc/cbci/casc' do
  action :create
  owner 'root'
  group 'root'
  mode '0755'
  recursive true
end

casc_files = [
  'bundle.yaml',
  'items.yaml',
  'jenkins.yaml',
  'plugin-catalog.yaml',
  'plugins.yaml',
  'rbac.yaml',
]

casc_files.each do |file|
  cookbook_file "/etc/cbci/casc/#{file}" do
    source "casc/#{file}"
    owner 'root'
    group 'root'
    mode '0644'
    action :create
  end
end
