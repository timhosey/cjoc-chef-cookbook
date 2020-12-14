plugins = {
  'beer': {
    'version': '1.0',
    'source': 'https://updates.jenkins.io/download/plugins/beer/1.0/beer.hpi',
  },
}

plugins.each do |plugin_name, value|
  install_or_update_plugin "update/install #{plugin_name}" do
    version ''
    plugin plugin_name

  end
end