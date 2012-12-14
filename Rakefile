#!/usr/bin/env rake
require "bundler/gem_tasks"

desc "Runs the simply test app"
task :test_app do
  require File.expand_path('../test/testapp.rb', __FILE__)
end

desc "Runs the simply test app"
task :reservations do
  require File.expand_path('../lib/wisebedclientruby.rb', __FILE__)
  puts Wisebed::Testbed.new("uzl").public_reservations(Time.now, Time.now+60*60*24)
end
