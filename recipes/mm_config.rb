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
  owner 'cloudbees-core-cm'
  group 'cloudbees-core-cm'
  mode '0755'
  recursive true
end

# Copy the casc-bundle-link.yaml file
cookbook_file '/var/lib/cloudbees-core-cm/casc-bundle-link.yaml' do
  source 'casc/casc-bundle-link.yaml'
  owner 'cloudbees-core-cm'
  group 'cloudbees-core-cm'
  mode '0644'
  action :create
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
    owner 'cloudbees-core-cm'
    group 'cloudbees-core-cm'
    mode '0644'
    action :create
  end
end
