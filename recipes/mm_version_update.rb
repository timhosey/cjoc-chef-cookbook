# Makes sure the correct apt repo is setup
apt_repository 'add cjmc repo' do
  uri 'https://downloads.cloudbees.com/cloudbees-core/traditional/client-master/rolling/debian'
  components ['binary/']
  action :add
  key 'https://downloads.cloudbees.com/cloudbees-core/traditional/operations-center/rolling/debian/cloudbees.com.key'
end

# Updates apt
apt_update 'update cjmc repo' do
  ignore_failure true
  action :periodic
  frequency 21600
end

cjoc_install_jenkins 'upgrade jenkins' do
  version node['cjcm']['target_version']
  package 'cloudbees-core-cm'
end
