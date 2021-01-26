property :version, String, required: true
property :plugin, String, required: true
property :plugin_source, String, required: true
property :plugin_path, String, default: '/var/lib/cloudbees-core-oc/plugins'

# /var/lib/cloudbees-core-oc/plugins

jenkins = nil

action :install_plugin do
  begin
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

    # Test to see if Jenkins is even available
    server_root = jenkins.get_root
    server_date = jenkins.get_server_date

    puts "\n*** Server Info: Root [#{server_root}] / Date [#{server_date}]"

    puts "\n*** PLUGIN INSTALL: Waiting for Jenkins API to be ready..."
    jenkins.system.wait_for_ready

    info = jenkins.plugin.list_installed
    if info.key?(new_resource.plugin)
      upgrade = info[new_resource.plugin] < new_resource.version
      downgrade = info[new_resource.plugin] > new_resource.version
      if upgrade || downgrade
        # upgrade or downgrade
        verb = upgrade ? 'Upgrading' : 'Downgrading'
        puts "\n*** PLUGIN INSTALL: #{verb} plugin #{new_resource.plugin} to #{new_resource.version}"
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
    # TODO: Detect if the plugins were updated or not so we can restart Jenkins
    ruby_block 'restart Jenkins' do
      block do
        if restart_jenkins
          puts "\n*** PLUGIN INSTALL: Restarting Jenkins when all jobs have finished..."
          jenkins.system.restart(false)
        else
          puts "\n*** PLUGIN INSTALL: Skipping restart on this plugin."
        end
      end
      action :nothing
    end
  rescue
    puts "\n*** Problem installing/updating plugins. Jenkins may be unavailable or not configured properly."
  end
end
