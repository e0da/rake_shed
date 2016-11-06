class License

  NAME             = (`git config --get user.name` or '').chomp.freeze
  EMAIL            = (`git config --get user.email` or '').chomp.freeze
  EMPLOYER_NAME    = 'TrackR'.freeze

  PREFERRED_LICENSES = {
    employer: :mit,
    personal: :isc,
  }.freeze

  PREFERRED_LICENSE_HOLDER = :employer

  HOLDERS = {
    employer: EMPLOYER_NAME,
    personal: "#{NAME} <#{EMAIL}>".freeze,
  }.freeze

  STATIC_LICENSE_TEMPLATES = {
    unlicense: {
      template:  'unlicense.txt.erb'.freeze,
      url:       'http://unlicense.org'.freeze,
    }.freeze,
  }.freeze

  DYNAMIC_LICENSE_TEMPLATE = {
    template:  "%{key}_license.txt.erb".freeze,
    url:       "http://www.opensource.org/licenses/%{slug}".freeze,
  }

  class << self

    def write(license_key, holder_key=nil)
      license = licenses[license_key]
      puts license[:url]
      target_file = "#{Rake.application.original_dir}/LICENSE"
      opts = OpenStruct.new({
        year:   Time.now.year,
        holder: HOLDERS[holder_key],
      })
      template = open(template_file_path(license[:template]), 'r') {|f| f.read}
      render = ERB.new(template).result(opts.instance_eval {binding})
      open(target_file, 'w') {|f| f.write render}
    end

    def preferred_license(party = PREFERRED_LICENSE_HOLDER)
      PREFERRED_LICENSES[party]
    end

    def write_preferred(party = PREFERRED_LICENSE_HOLDER)
      write PREFERRED_LICENSES[party], party
    end

    private

    def dynamic_license_templates
      %w[mit isc].reduce({}) do |memo, lic|
        memo[lic.to_sym] = {
          template: (DYNAMIC_LICENSE_TEMPLATE[:template] % {key: lic}).freeze,
          url: (DYNAMIC_LICENSE_TEMPLATE[:url] % {slug: lic.upcase}).freeze,
        }.freeze
        memo
      end.freeze
    end

    def licenses
      STATIC_LICENSE_TEMPLATES.merge dynamic_license_templates
    end

    def template_file_path(file)
      "#{File.dirname __FILE__}/../templates/#{file}"
    end
  end
end

