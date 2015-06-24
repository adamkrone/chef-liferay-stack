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
        include_recipe 'database::mysql'

        new_resource.hosts.each do |current_host|
          mysql_database_user new_resource.user do
            connection new_resource.mysql_connection_info
            password new_resource.user_password
            host current_host
            action :create
          end
        end

        Chef::Log.info("Creating database: #{new_resource.name}")

        mysql_database new_resource.name do
          connection new_resource.mysql_connection_info
          action :create
        end

        mysql_database_user new_resource.user do
          connection new_resource.mysql_connection_info
          database_name new_resource.name
          privileges [:all]
          action :grant
        end
      end
    end
  end
end
