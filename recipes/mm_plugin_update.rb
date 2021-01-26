begin
  node['master_plugins'].each_with_index do |u, index|
    plugin_name = u[1][:name]
    plugin_ver = u[1][:version]
    plugin_url = u[1][:source]
    jenkins_restart = index == node['master_plugins'].size - 1

    # TODO: Detect if the plugins were updated or not so we can restart Jenkins

    cjoc_install_plugin "update/install #{plugin_name}" do
      version plugin_ver
      plugin plugin_name.to_s
      plugin_source plugin_url
      plugin_path '/var/lib/cloudbees-core-cm/plugins'
    end
  end
rescue
  puts '*** Problem installing/updating plugins. Jenkins may be unavailable or not configured properly.'
end
