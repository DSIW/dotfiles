require 'rake'
require 'pathname'
require 'erb'

DOTFILE_EXT        = "symlink"
ERB_EXT            = "erb"
BACKUP_EXT         = "bak"
REPO               = File.join(ENV['HOME'], ".dotfiles")
PATH_FOR_DIRS      = ""
PATH_FOR_BINS      = "_bin"
PATH_FOR_OH_MY_ZSH = ".oh-my-zsh"
IGNORE_FILES       = [/^#{PATH_FOR_BINS}/, /^#{PATH_FOR_DIRS}/, /^\.git.*$/, /^Rakefile$/, /^README.*$/]

#files = `git ls-files`.split("\n")
#files.reject! { |f| IGNORE_FILES.any? { |re| f.match(re) } }

desc "Hook our dotfiles into system-standard positions."
task :install do
  skip_all = false
  overwrite_all = false
  backup_all = false

  dotfiles do |dotfile|
    overwrite = false
    backup = false

    target = target_of dotfile

    if File.exists?(target) || File.symlink?(target)
      unless skip_all || overwrite_all || backup_all
        puts "File already exists: #{target}, what do you want to do? [s]kip, [S]kip all, [o]verwrite, [O]verwrite all, [b]ackup, [B]ackup all"
        case STDIN.gets.chomp
        when 'o' then overwrite     = true
        when 'b' then backup        = true
        when 'O' then overwrite_all = true
        when 'B' then backup_all    = true
        when 'S' then skip_all      = true
        when 's' then next
        end
      end
      FileUtils.rm_rf(target) if overwrite || overwrite_all
      backup_file file if backup || backup_all
    end
    if !skip_all || !File.exist?(target)
      link_file dotfile
    end
  end
end

desc "Install script to bin"
task :install_bin do
  BINS = Dir["#{REPO}/#{PATH_FOR_BINS}/*"]
  puts "No binaries!" if BINS.empty?
  BINS.each do |file|
    target_file = File.join(target_dir, 'sys', 'bin', Pathname.new(file).basename)
    FileUtils.cp file, target_file, :preserve => true, :verbose => true
    puts "Installed #{file} to #{target_file}"
  end
end

desc "Delete all symlinked files from home dir. Restores backup if exists"
task :uninstall do
  dotfile_targets do |target|
    # Remove all symlinks created during installation
    if File.symlink? target
      FileUtils.rm target, :verbose => true
    end

    # Replace any backups made during installation
    if File.exists? "#{target}.#{BACKUP_EXT}"
      restore_file file
    end
  end
end

desc "Add files to dotfiles repository. (e.g. glob: ~/.*[^~])"
task :add, :glob do |t, args|
  expanded_glob = File.expand_path(args[:glob])
  remove_pseudo_dirs(expanded_glob).each do |filename|
    next if !File.file?(filename) && !File.directory?(filename) || File.symlink?(filename)
    if File.dirname(filename).include? REPO
      puts "File '#{filename}' does already exist in repository (#{REPO})."
      next
    end
    target = prepare_filename(filename)
    FileUtils.mv(filename, File.join(REPO, target), :verbose => true)
  end
end

desc "Sync dotfiles with filesystem"
task :sync do
  Rake::Task[:uninstall].execute
  Rake::Task[:install].execute
end

desc "Update all dotfiles and sync them"
task :update do
  puts `git pull --rebase --recurse-submodules origin master`
  Rake::Task[:sync].execute
end

desc "list tasks"
task :list do
  puts "Tasks: #{(Rake::Task.tasks - [Rake::Task[:list]]).join(', ')}"
  puts "(type rake -T for more detail)\n\n"
end

desc "Switch to ZSH (install unless exists)"
task :init_zsh do
  install_oh_my_zsh
  switch_to_zsh
end

desc "Init VIM with Vundle"
task :init_vim do
  puts "Installing Vundle"
  puts `git clone http://github.com/gmarik/vundle.git "~/.vim/bundle/vundle"`
  puts "Please run 'vim +BundleInstall! +BundleClean +q' to get bundles"
end

task :default => ['list']

def remove_pseudo_dirs glob
  dirname = Pathname.new(glob).dirname
  pseudo_dirs = %w[. ..]
  pseudo_with_path = pseudo_dirs.map {|file| File.join(File.expand_path(dirname), file)}
  Dir[glob] - pseudo_with_path
end

def backup_file file
  puts "backup #{file}"
  FileUtils.cp(target_of(file), backup_of(file))
end

def restore_file file
  puts "restore #{file}"
  FileUtils.mv(backup_of(file), target_of(file), :verbose => true)
end

def rm_backup_file file
  backup = backup_of file
  puts "rm backup #{backup}"
  FileUtils.rm_f(file)
end

def dotfiles
  Dir["#{REPO}/**/*.{#{DOTFILE_EXT},#{ERB_EXT}}"].map { |file| yield file }
end

def dotfile_targets
  dotfiles { |file| yield target_of(file) }
end

# Examples:
# * .../file -> ~/.dotfiles/file.symlink
# * .../dir  -> ~/.dotfiles/_dirs/dir.symlink
def prepare_filename file
  is_dir = File.directory? file

  basename = rm_basename_ext file
  basename = basename[1..-1] if basename.start_with? "." # remove first "."

  path = Pathname.new(".") # like empty pathname
  path += Pathname.new(PATH_FOR_DIRS) if is_dir
  path += "#{basename}.#{DOTFILE_EXT}"
end

def replace_file file
  FileUtils.rm_rf target_of(file)
  link_file file
end

def link_file file
  target = target_of file
  if file =~ /.#{ERB_EXT}$/
    generate_file file
  else
    puts "linking #{target}"
    FileUtils.ln_s(file, target, :verbose => false)
  end
end

def generate_file file
  target = target_of file
  puts "generating #{target}"
  File.open(target, 'w') do |new_file|
    new_file.write ERB.new(File.read(file)).result(binding)
  end
rescue Interrupt
end

def rm_erb_ext file
  file.sub(/\.#{ERB_EXT}$/, '')
end

def rm_basename_ext file
  path = Pathname.new(file)
  path.basename.sub(/\.(#{DOTFILE_EXT}|#{ERB_EXT})$/, '').to_s
end

def target_of file
  basename = rm_basename_ext(file)
  basename = basename[1..-1] if basename.start_with? "." # remove first "."
  File.join(ENV["HOME"], ".#{basename}")
end

def backup_of file
  File.join(ENV['HOME'], "#{rm_basename_ext(file)}.#{BACKUP_EXT}")
end

def switch_to_zsh
  if ENV["SHELL"] =~ /zsh/
    puts "Using ZSH"
  else
    print "Switch to ZSH? (recommended) [ynq] "
    case $stdin.gets.chomp
    when 'y'
      puts "Switching to ZSH"
      system %Q{chsh -s `which zsh`}
    when 'q'
      exit
    else
      puts "Skipping ZSH"
    end
  end
end

def install_oh_my_zsh
  if File.exist?(File.join(ENV['HOME'], "#{PATH_FOR_OH_MY_ZSH}"))
    puts "Found #{ENV['HOME']}/#{PATH_FOR_OH_MY_ZSH}"
  else
    print "Install oh-my-zsh? [ynq] "
    case $stdin.gets.chomp
    when 'y'
      puts "Installing oh-my-zsh"
      system %Q{git clone https://github.com/robbyrussell/oh-my-zsh.git "#{ENV['HOME']}/#{PATH_FOR_OH_MY_ZSH}"}
    when 'q'
      exit
    else
      puts "Skipping oh-my-zsh, you will need to change #{ENV['HOME']}/.zshrc"
    end
  end
end
