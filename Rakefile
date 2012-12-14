#!/usr/bin/env rake
require "bundler/gem_tasks"

desc "Runs the simply test app"
task :test_app do
  require File.expand_path('../test/testapp.rb', __FILE__)
end

namespace :reservation do
  
  desc "lists current reservations on uzl"
  task :list do
    require File.expand_path('../lib/wisebedclientruby.rb', __FILE__)
    res = Wisebed::Testbed.new("uzl").public_reservations(Time.now.utc, Time.now.utc+60*60*24)
    res.each do |r|
        puts "#{r["userData"]} : #{Time.at(r["from"]/1000)} -> #{Time.at(r["to"]/1000)}"
    end
  end

  desc "deletes a reservation"
  task :delete do
    require File.expand_path('../lib/wisebedclientruby.rb', __FILE__)
    tb = Wisebed::Testbed.new("uzl")
    logindata = YAML.load_file(File.expand_path('../test/credentials.yml', __FILE__))
    tb.login!(logindata)
    tb.delete_reservation(JSON.parse(ENV['res']))        
  end
      
end

