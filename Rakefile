def rake_dir
  "#{ENV['HOME']}/.rake"
end

def rake_shed_root_install_path
  File.expand_path(File.dirname(__FILE__))
end

def source_path(file)
  "#{rake_shed_root_install_path}/#{file}"
end

def target_path(file)
  "#{rake_dir}/#{file}"
end

def forcing?
  ENV['force']
end

def link_to_rake_dir(file)
  source = source_path(file)
  target = target_path(file)
  mkdir_p rake_dir
  rm target if forcing?
  if File.exists?(target)
    warn "#{target} exists. Add force=yes to overwrite."
  else
    symlink source, target
  end
end

desc 'Install the rake tasks (symlink them into ~/.rake)'
task install: 'symlink:rake_shed'

namespace :symlink do
  task rake_shed: :rake_shed_dir do
    link_to_rake_dir 'rake_shed.rake'
  end

  task :rake_shed_dir do
    link_to_rake_dir 'rake_shed'
  end
end
