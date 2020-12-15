plugins = {
  'beer': {
    'version': '1.2',
    'source': 'https://updates.jenkins.io/download/plugins/beer/1.2/beer.hpi',
  },
}

plugins.each do |plugin_name, value|
  cjoc_install_plugin "update/install #{plugin_name}" do
    version value[:version]
    plugin plugin_name.to_s
    plugin_source value[:source]
  end
end