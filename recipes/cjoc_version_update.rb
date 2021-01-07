# frozen_string_literal: true

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
  frequency 21_600
end

cjoc_install_jenkins 'upgrade jenkins' do
  version node['cjoc']['target_version']
  package 'cloudbees-core-oc'
end
