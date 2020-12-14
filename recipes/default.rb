#
# Cookbook:: cjoc
# Recipe:: default
#
# Copyright:: 2020, The Authors, All Rights Reserved.

include_recipe 'chef-client::default'

include_recipe '::version_update'

include_recipe '::cjoc_config'

include_recipe '::plugin_update'
