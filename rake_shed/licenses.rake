require 'erb'
require 'ostruct'

default_license_task = 'license:employer'
employer             = 'AppFolio'
employer_license     = :mit
name                 = (`git config --get user.name` or '').chomp

def licenses
  {
    mit: {
      template:  'mit_license.txt.erb',
      url:       'http://www.opensource.org/licenses/MIT',
    },
    unlicense: {
      template:  'unlicense.txt.erb',
      url:       'http://unlicense.org',
    },
  }
end

def template_file_path(file)
  "#{ENV['HOME']}/.rake/rake_shed/templates/#{file}"
end

def write_license(license_key, holder)
  license = licenses[license_key]
  puts license[:url]
  target_file = "#{Rake.application.original_dir}/LICENSE"
  opts = OpenStruct.new({
    year:   Time.now.year,
    holder: holder,
  })
  template = open(template_file_path(license[:template]), 'r') {|f| f.read}
  render = ERB.new(template).result(opts.instance_eval {binding})
  open(target_file, 'w') {|f| f.write render}
end

desc "Default license: (#{default_license_task})"
task license: default_license_task

namespace :license do
  desc 'Print the URL to the preferred employer license and output the LICENSE text to ./LICENSE'
  task :employer do
    write_license employer_license, employer
  end

  desc 'Print the URL to the MIT license and output the LICENSE text to ./LICENSE'
  task :mit do
    write_license :mit, name
  end

  desc 'Print the URL to the unlicense and output the LICENSE text to ./LICENSE'
  task :unlicense do
    write_license :unlicense, name
  end
end
