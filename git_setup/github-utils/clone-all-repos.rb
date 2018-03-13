#! /usr/bin/env ruby

require 'optparse'
require 'ostruct'
require 'octokit'

options = OpenStruct.new

options.directory = "~/git/"

OptionParser.new do |opts|
  opts.banner = "Usage: clone-all-repos.rb [options]"
  opts.on("-u USER", "--user USER", "GitHub username") do |user|
    options.user = user
  end
  opts.on("-p PASSWORD", "--password PASSWORD", "GitHub password") do |password|
    options.password = password
  end
  opts.on("-d DIR", "--directory DIR", "Directory to clone repos under") do |dir|
    options.directory = dir
  end
end.parse!

if (options.user.nil?) or (options.password.nil?) then
  raise ArgumentError, "Username and/or password not provided."
end

puts "Logging in as #{options.user}"

client = Octokit::Client.new \
  :login    => options.user,
  :password => options.password

puts "Creating directory #{options.directory} to host repos"
`mkdir -p #{options.directory}`

client.repos.each do |r|
  puts "Cloning repo #{r.full_name}"
  `git clone git@github.com:#{r.full_name}.git #{options.directory}#{r.name}`
end
