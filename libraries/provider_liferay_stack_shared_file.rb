#
# Cookbook:: liferay_stack
# Provider:: liferay_stack_shared_file
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
    class LiferayStackSharedFile < Chef::Provider::LWRPBase
      include Chef::DSL::IncludeRecipe
      use_inline_resources if defined?(use_inline_resources)
      provides :liferay_stack_shared_file

      def whyrun_supported?
        true
      end

      action :create do
        directory new_resource.shared_dir do
          owner new_resource.owner
          group new_resource.group
          recursive true
          action :create
        end

        current_sub_dir = []

        new_resource.sub_dirs.each do |current_dir|
          current_sub_dir << current_dir
          directory ::File.join(new_resource.shared_dir, current_sub_dir) do
            owner new_resource.owner
            group new_resource.group
            recursive true
            action :create
          end
        end

        template ::File.join(new_resource.shared_dir, new_resource.sub_dirs, new_resource.file_name) do
          source new_resource.template
          owner new_resource.owner
          group new_resource.group
          action :create
        end
      end
    end
  end
end
