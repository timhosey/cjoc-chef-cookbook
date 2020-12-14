property :version, String, required: true
property :plugin, String, required: true
property :plugin_source, String, required: true
property :plugin_path, String, default: '/var/lib/cloudbees-core-oc/plugins'

# /var/lib/cloudbees-core-oc/plugins

action :install_plugin do
  # Install gem into Chef
  chef_gem 'jenkins_api_client' do
    compile_time true
  end

  # Requiring YAML so I don't have to keep username/pass in git
  require 'yaml'

  # Workaround to test without putting creds on github
  `test -f '/tmp/jenkins_api.yml'`
  creds = $?.success? ? YAML.load(IO.read('/tmp/jenkins_api.yml')) : YAML.load(IO.read('jenkins_api.yml'))

  require 'jenkins_api_client'
  @client = JenkinsApi::Client.new(
    server_url: creds['server'],
    username: creds['username'],
    password: creds['password']
  )

  info = @client.plugin.list_installed
  if info.key?(new_resource.plugin)
    if info[new_resource.plugin] < new_resource.version
      # upgrade
      puts 'WE NEED TO UPGRADE!'
    end
  else
    # install
    remote_file new_resource.plugin_path do
      source "#{new_resource.plugin_source}"
      owner 'root'
      group 'root'
      mode '0755'
      action :create
    end
  end

  # Wait until jobs finish to restart
  if @client.plugin.restart_required?
    @client.system.restart(false)
  end
end