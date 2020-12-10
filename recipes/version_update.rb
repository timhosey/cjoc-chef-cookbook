# Makes sure the correct apt repo is setup
apt_repository 'add cjoc repo' do
  uri 'https://downloads.cloudbees.com/cloudbees-core/traditional/client-master/rolling/debian'
  components ['binary/']
  action :add
  key 'https://downloads.cloudbees.com/cloudbees-core/traditional/operations-center/rolling/debian/cloudbees.com.key'
end

# Updates apt
apt_update 'update cjoc repo' do
  ignore_failure true
  action :periodic
  frequency 21600
end

cjoc_install_jenkins 'upgrade jenkins' do
  version node['cjoc']['target_version']
  package 'cloudbees-core-oc'
end

# # Checks APT for a version change and upgrades if needed.
# apt_package 'cloudbees-core-oc' do
#   version node['cjoc']['target_version']
#   options ['--allow-downgrades', '--allow-change-held-packages']
#   action :upgrade
# end
