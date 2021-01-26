node['master_plugins'].each_with_index do |u, index|
  plugin_name = u[1][:name]
  plugin_ver = u[1][:version]
  plugin_url = u[1][:source]

  cjoc_install_plugin "update/install #{plugin_name}" do
    version plugin_ver
    plugin plugin_name.to_s
    plugin_source plugin_url
    plugin_path '/var/lib/cloudbees-core-cm/plugins'
  end
end
