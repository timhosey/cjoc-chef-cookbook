property :version, String, required: true
property :plugin, String, required: true
property :plugin_source, String, required: true
property :plugin_path, String, default: '/var/lib/cloudbees-core-oc/plugins'
property :restart, [TrueClass, FalseClass], default: false

# /var/lib/cloudbees-core-oc/plugins

jenkins = nil

action :install_plugin do
  # Install gem into Chef
  chef_gem 'jenkins_api_client' do
    compile_time true
  end

  # Requiring YAML so I don't have to keep username/pass in git
  require 'yaml'

  # Workaround to test without putting creds on github
  `test -f '/tmp/jenkins_api.yml'`
  creds = $CHILD_STATUS.success? ? YAML.safe_load(IO.read('/tmp/jenkins_api.yml')) : YAML.safe_load(IO.read('jenkins_api.yml'))

  require 'jenkins_api_client'
  jenkins = JenkinsApi::Client.new(
    server_url: creds['server'],
    username: creds['username'],
    password: creds['password']
  )

  puts "\n*** PLUGIN INSTALL: Waiting for Jenkins API to be ready..."
  jenkins.system.wait_for_ready

  info = jenkins.plugin.list_installed
  if info.key?(new_resource.plugin)
    if info[new_resource.plugin] < new_resource.version
      # upgrade
      puts "\n*** PLUGIN INSTALL: Upgrading plugin #{new_resource.plugin} to #{new_resource.version}"
      remote_file "#{new_resource.plugin_path}/#{new_resource.plugin}.jpi" do
        source new_resource.plugin_source.to_s
        owner 'root'
        group 'root'
        mode '0755'
        action :create
        notifies :run, 'ruby_block[restart Jenkins]', :delayed
      end
    end
  else
    # install
    puts "\n*** PLUGIN INSTALL: Installing new plugin #{new_resource.plugin} to #{new_resource.version}"
    remote_file "#{new_resource.plugin_path}/#{new_resource.plugin}.jpi" do
      source new_resource.plugin_source.to_s
      owner 'root'
      group 'root'
      mode '0755'
      action :create
      notifies :run, 'ruby_block[restart Jenkins]', :delayed
    end
  end
  # Restart...
  ruby_block 'restart Jenkins' do
    block do
      if new_resource.restart
        puts "\n*** PLUGIN INSTALL: Restarting Jenkins when all jobs have finished..."
        jenkins.system.restart(false)
      else
        puts "\n*** PLUGIN INSTALL: Skipping restart on this plugin."
      end
    end
    action :nothing
  end
end
