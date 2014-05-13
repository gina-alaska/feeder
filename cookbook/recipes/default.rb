#
# Cookbook Name:: puffin-cookbook
# Recipe:: default
#
# Copyright (C) 2013 YOUR_NAME
# 
# All rights reserved - Do Not Redistribute
#


include_recipe "puffin::redis"
include_recipe "puffin::database"
include_recipe "puffin::nginx"
include_recipe "puffin::application"
include_recipe "puffin::unicorn"
include_recipe "puffin::sidekiq"
