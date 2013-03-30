#
# Cookbook Name:: nodebrew
# Recipe:: default
#
# Copyright 2013
#
# All rights reserved - Do Not Redistribute
#

remote_file "/tmp/nodebrew" do |variable|
  source "http://git.io/nodebrew"
end

script "setup" do
  interpreter "bash"
  user  node['nodebrew']['name']
  group node['nodebrew']['group']
  cwd   node['nodebrew']['home']
  code "perl /tmp/nodebrew setup"
end

ruby_block "add path" do
  block do
    file = Chef::Util::FileEdit.new("#{node['nodebrew']['home']}/.bashrc")
    file.insert_line_if_no_match(
      "PATH=$HOME/.nodebrew/current/bin:$PATH",
      "PATH=$HOME/.nodebrew/current/bin:$PATH"
    )
    file.write_file
  end
end

script "install" do
  interpreter "bash"
  path  ["$HOME/.nodebrew"]
  user  node['nodebrew']['name']
  group node['nodebrew']['group']
  cwd   node['nodebrew']['home']
  code "$HOME/.nodebrew/nodebrew install-binary #{node['nodebrew']['version']}"
end
script "use" do
  interpreter "bash"
  path  ["$HOME/.nodebrew"]
  user  node['nodebrew']['name']
  group node['nodebrew']['group']
  cwd   node['nodebrew']['home']
  code "$HOME/.nodebrew/nodebrew use #{node['nodebrew']['version']}"
end