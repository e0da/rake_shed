RAKE_SHED_DIR = "#{ENV['HOME']}/.rake/rake_shed"

Dir.glob("#{ENV['HOME']}/.rake/rake_shed/*.rake").each do |rakefile|
  import rakefile
end
