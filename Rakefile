# frozen_string_literal: true

require 'rubygems'
require 'bundler/setup'

require 'rake'

task :environment do
  ENV['RACK_ENV'] ||= 'development'
  require File.expand_path('config/environment', __dir__)
end

task routes: :environment do
  Zoldy::API.routes.each do |route|
    method = route.request_method.ljust(10)
    path = route.origin
    puts "     #{method} #{path}"
  end
end

begin
  require 'rspec/core/rake_task'
  RSpec::Core::RakeTask.new(:spec)
rescue LoadError
end

require 'rubocop/rake_task'

RuboCop::RakeTask.new(:rubocop) do |t|
  t.options = ['--display-cop-names']
end

task default: %i[spec rubocop]
