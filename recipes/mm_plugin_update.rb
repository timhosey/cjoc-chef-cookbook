node['master_plugins'].each do |plugin_name, value|
  cjoc_install_plugin "update/install #{plugin_name}" do
    version value[:version]
    plugin plugin_name.to_s
    plugin_source value[:source]
  end
end
