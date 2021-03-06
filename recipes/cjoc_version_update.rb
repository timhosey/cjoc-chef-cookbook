# Makes sure the correct apt repo is setup
apt_repository 'add cjoc repo' do
  uri 'https://downloads.cloudbees.com/cloudbees-core/traditional/client-master/rolling/debian'
  distribution 'binary/'
  action :add
  key 'https://downloads.cloudbees.com/cloudbees-core/traditional/operations-center/rolling/debian/cloudbees.com.key'
  deb_src true
  cache_rebuild true
end

# Updates apt
apt_update 'update cjoc repo' do
  ignore_failure true
  action :periodic
  frequency 21600
end

package 'openjdk-8-jdk' do
  action :install
end

cjoc_install_jenkins 'upgrade jenkins' do
  version node['cjoc']['target_version']
  package 'cloudbees-core-oc'
end
