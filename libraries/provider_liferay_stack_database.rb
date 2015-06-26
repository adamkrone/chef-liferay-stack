#
# Cookbook:: liferay_stack
# Provider:: liferay_stack_database
#
# Copyright 2015 Adam Krone <adam.krone@thirdwavellc.com>
# Copyright 2015 Thirdwave, LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

require 'chef/provider/lwrp_base'

class Chef
  class Provider
    class LiferayStackDatabase < Chef::Provider::LWRPBase
      include Chef::DSL::IncludeRecipe
      use_inline_resources if defined?(use_inline_resources)

      def whyrun_supported?
        true
      end

      action :create do
        create_db_command = "create database if not exists #{new_resource.name}"

        execute "create db '#{new_resource.name}'" do
          command "mysql -u root -p#{new_resource.mysql_root_password} -e \"#{create_db_command}\""
        end

        new_resource.hosts.each do |current_host|
          create_user_command = "create user '#{new_resource.user}'@'#{current_host}' identified by '#{new_resource.user_password}'"

          execute "create db user '#{new_resource.user}'" do
            command "mysql -u root -p#{new_resource.mysql_root_password} -e \"#{create_user_command}\""
            not_if "mysql -u root -p#{new_resource.mysql_root_password} -D mysql -e \"select User from user\" | grep #{new_resource.user}"
          end

          grant_privileges_command = "grant all privileges on #{new_resource.name}.* to '#{new_resource.user}'@'#{current_host}'"

          execute "grant '#{new_resource.user}'@'#{current_host}' privileges on db '#{new_resource.name}'" do
            command "mysql -u root -p#{new_resource.mysql_root_password} -e \"#{grant_privileges_command}\""
            not_if "mysql -u #{new_resource.user} -p#{new_resource.user_password} -e \"show databases\" | grep #{new_resource.name}"
          end
        end

        execute 'flush privileges' do
          command "mysql -u root -p#{new_resource.mysql_root_password} -e 'flush privileges'"
          not_if "mysql -u root -p#{new_resource.mysql_root_password} -D mysql -e \"select User from user\" | grep #{new_resource.user}"
        end
      end
    end
  end
end
