require 'erb'
require 'ostruct'
require_relative 'lib/license'

default_license_task = "license:employer"

desc "Default license: (#{default_license_task})"
task license: default_license_task

namespace :license do

  %w[employer personal].map(&:to_sym).each do |party|
    desc "Print the URL to the preferred #{party} license and output the LICENSE text to ./LICENSE"
    task party do
      License.write_preferred party
    end
  end

  %w[isc mit].each do |lic|
    desc "Print the URL to the #{lic.upcase} license and output the LICENSE text to ./LICENSE"
    task lic.to_sym do
      License.write lic.to_sym, :personal
    end
  end

  desc 'Print the URL to the unlicense and output the LICENSE text to ./LICENSE'
  task :unlicense do
    License.write :unlicense
  end
end
