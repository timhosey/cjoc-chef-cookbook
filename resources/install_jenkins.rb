# frozen_string_literal: true

# dpkg -s cloudbees-core-oc | grep -i version | sed 's/[A-Za-z\:\s-]//g'

property :version, String, required: true
property :package, String, required: true

action :install_jenkins do
  # Use bash to get current version of application
  installed_version = `dpkg -s #{new_resource.package} | grep -i version | sed 's/[A-Za-z\:\s-]//g'`.strip.gsub(/\s+/, '')

  if installed_version != new_resource.version
    bash 'upgrade jenkins' do
      code <<-EOH
      apt-get --assume-yes --allow-downgrades install #{new_resource.package}=#{new_resource.version}
      EOH
      action :run
    end
  end
end
