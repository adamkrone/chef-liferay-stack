#
# Cookbook:: liferay_stack
# Resource:: liferay_stack_app
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

require 'chef/resource/lwrp_base'

class Chef
  class Resource
    class LiferayStackApp < Chef::Resource::LWRPBase
      self.resource_name = :liferay_stack_app
      actions :create
      default_action :create

      attribute :app_name, kind_of: String, name_attribute: true
      attribute :deployment_user, kind_of: String, default: 'liferay'
      attribute :deployment_group, kind_of: String, default: 'liferay'
      attribute :home_dir, kind_of: String, default: '/opt/liferay/current/liferay-portal-6.2-ce-ga4'
      attribute :tomcat_dir, kind_of: String, default: '/opt/liferay/current/liferay-portal-6.2-ce-ga4/tomcat-7.0.42'
      attribute :log_dir, kind_of: String, default: '/opt/liferay/current/liferay-portal-6.2-ce-ga4/tomcat-7.0.42/logs'
      attribute :github_accounts, kind_of: Array, required: true
      attribute :provision_github_accounts, equal_to: [true, false], default: false
    end
  end
end
