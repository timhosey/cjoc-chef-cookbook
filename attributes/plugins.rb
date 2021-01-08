default['cjoc_plugins'] = {
  'beer': {
    'version': '1.2',
    'source': 'https://updates.jenkins.io/download/plugins/beer/1.2/beer.hpi',
  },
}

default['master_plugins'] = {
  'beer': {
    'name': 'beer',
    'version': '1.2',
    'source': 'https://updates.jenkins.io/download/plugins/beer/1.2/beer.hpi',
  },
  'configuration-as-code': {
    'name': 'configuration-as-code',
    'version': '1.46',
    'source': 'https://updates.jenkins.io/download/plugins/configuration-as-code/1.46/configuration-as-code.hpi',
  },
}
