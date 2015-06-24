#
# Cookbook:: liferay_stack
# Provider:: liferay_stack__app
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
    class LiferayStackApp < Chef::Provider::LWRPBase
      include Chef::DSL::IncludeRecipe
      use_inline_resources if defined?(use_inline_resources)

      def whyrun_supported?
        true
      end

      action :create do
        include_recipe 'apt::default' if platform_family? 'debian'
        include_recipe 'yum::default' if platform_family? 'rhel'

        include_recipe 'unzip::default'

        capistrano_user new_resource.deployment_user do
          group new_resource.deployment_group
          group_id 8000
        end

        ssh_import_id new_resource.deployment_user do
          github_accounts new_resource.github_accounts
        end

        liferay_app new_resource.app_name do
          user new_resource.deployment_user
          group new_resource.deployment_group
          home_dir new_resource.home_dir
          tomcat_dir new_resource.tomcat_dir
          log_dir new_resource.log_dir
          action :create
        end
      end
    end
  end
end
