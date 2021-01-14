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

# Copy CasC files; make dir if it doesn't exist
directory '/var/lib/cloudbees-core-oc/jcasc-bundles-store/client-master' do
  action :create
  owner 'cloudbees-core-oc'
  group 'cloudbees-core-oc'
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
  cookbook_file "/var/lib/cloudbees-core-oc/jcasc-bundles-store/client-master/#{file}" do
    source "casc/#{file}"
    owner 'cloudbees-core-oc'
    group 'cloudbees-core-oc'
    mode '0644'
    action :create
  end
end
