# frozen_string_literal: true

#
# Cookbook:: cjoc
# Recipe:: default
#
# Copyright:: 2020, The Authors, All Rights Reserved.

include_recipe 'chef-client::default'

# CJOC specific recipes
if node.name.include? 'cjoc'
  include_recipe '::cjoc_version_update'
  include_recipe '::cjoc_config'
  include_recipe '::cjoc_plugin_update'
# Master specific recipes
#else
  #include_recipe '::'
end
