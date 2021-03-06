#
# Cookbook:: liferay_stack
# Resource:: liferay_stack_database
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
    class LiferayStackDatabase < Chef::Resource::LWRPBase
      self.resource_name = :liferay_stack_database
      actions :create
      default_action :create

      attribute :name, kind_of: String, name_attribute: true
      attribute :user, kind_of: String, required: true
      attribute :user_password, kind_of: String, required: true
      attribute :hosts, kind_of: Array, required: true
      attribute :mysql_root_password, kind_of: String, required: true

      def mysql_connection_info
        { host:     'localhost',
          username: 'root',
          password: mysql_root_password }
      end
    end
  end
end
