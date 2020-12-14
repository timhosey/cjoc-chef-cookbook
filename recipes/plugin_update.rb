plugins = {
  'beer': {
    'version': '1.0',
    'source': 'https://updates.jenkins.io/download/plugins/beer/1.0/beer.hpi',
  },
}

plugins.each do |plugin_name, value|
  cjoc_install_plugin "update/install #{plugin_name}" do
    version '1.0'
    plugin plugin_name.to_s
    plugin_source value[:source]
  end
end