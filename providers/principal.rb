#
# Cookbook Name:: krb5
# Provider:: principal
#
# Copyright © 2014 Cask Data, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

# require 'rkerberos'

use_inline_resources if defined?(use_inline_resources)

def whyrun_supported?
  true
end

action :create do
  krb5_verify_admin
  kadm5 = kadm5_init(node['krb5']['admin_principal'], node['krb5']['admin_password'])
  mypass = 'placeholder12345' if new_resource.password.nil?
  begin
    kadm5.create_principal(new_resource.principal, mypass)
    kadm5.generate_random_key(new_resource.principal) if new_resource.randkey
  ensure
    kadm5.close
  end
end

action :delete do
  krb5_verify_admin
  kadm5 = kadm5_init(node['krb5']['admin_principal'], node['krb5']['admin_password'])
  begin
    kadm5.delete_principal(new_resource.principal)
  ensure
    kadm5.close
  end
end
