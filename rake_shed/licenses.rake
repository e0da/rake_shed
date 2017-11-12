require 'erb'
require 'ostruct'
require_relative 'lib/license'

default_license_task = "license:employer"

license_desc = %{Print URL and save '%s' license to ./LICENSE}

desc "Run #{default_license_task}"
task license: default_license_task

preferred_license = ->(party) { License::PREFERRED_LICENSES[party].upcase }

namespace :license do

  %w[employer personal].map(&:to_sym).each do |party|
    desc(license_desc % preferred_license.(party))
    task party do
      License.write_preferred party
    end
  end

  %w[isc mit].map(&:to_sym).each do |license|
    name = license.to_s.upcase
    desc(license_desc % name)
    task license do
      License.write license, :personal
    end
  end

  desc(license_desc % 'unlicense')
  task :unlicense do
    License.write :unlicense
  end
end
