require 'rake'
require 'pathname'
require 'pry'

DOTFILE_EXT        = "symlink"
BACKUP_EXT         = "backup"
REPO               = File.join(ENV['HOME'], ".dotfiles")
PATH_FOR_DIRS      = ""
PATH_FOR_BINS      = "_bin"
PATH_FOR_OH_MY_ZSH = ".oh-my-zsh"
IGNORE_FILES       = [/^#{PATH_FOR_BINS}/, /^#{PATH_FOR_DIRS}/, /^\.git.*$/, /^Rakefile$/, /^README.*$/]

files = `git ls-files`.split("\n")
files.reject! { |f| IGNORE_FILES.any? { |re| f.match(re) } }

desc "Hook our dotfiles into system-standard positions."
task :install do
  linkables = Dir[File.join("**", "*.#{DOTFILE_EXT}")]

  skip_all = false
  overwrite_all = false
  backup_all = false

  linkables.each do |linkable|
    overwrite = false
    backup = false

    file = linkable.split(File::SEPARATOR).last.split(".#{DOTFILE_EXT}").last
    target = File.join(ENV["HOME"], ".#{file}")

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
      FileUtils.mv(File.join(ENV['HOME'], ".#{file}"), File.join(ENV['HOME'], ".#{file}.#{BACKUP_EXT}")) if backup || backup_all
    end
    if skip_all
      FileUtils.ln_s(File.join(REPO, linkable), target, :verbose => true) unless File.exist?(target)
    else
      FileUtils.ln_s(File.join(REPO, linkable), target, :verbose => true)
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
  Dir["#{REPO}/**/*.#{DOTFILE_EXT}"].each do |linkable|

    file = linkable.split('/').last.split(".#{DOTFILE_EXT}").last
    target = File.join(ENV["HOME"], ".#{file}")

    # Remove all symlinks created during installation
    if File.symlink? target
      FileUtils.rm target, :verbose => true
    end

    # Replace any backups made during installation
    if File.exists? "#{ENV["HOME"]}/.#{file}.#{BACKUP_EXT}"
      FileUtils.mv("ENV['HOME']/.#{file}.#{BACKUP_EXT}", "#{ENV['HOME']}/.#{file}", :verbose => true)
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

task :default => ['list']

def remove_pseudo_dirs glob
  dirname = Pathname.new(glob).dirname
  pseudo_dirs = %w[. ..]
  pseudo_with_path = pseudo_dirs.map {|file| File.join(File.expand_path(dirname), file)}
  Dir[glob] - pseudo_with_path
end

def prepare_filename file
  is_dir = File.directory? file

  pathname = Pathname.new(file)
  basename = pathname.basename.to_s
  basename = basename[1..-1] if basename.start_with? "." # remove first "."

  path = Pathname.new(".") # like empty pathname
  path += Pathname.new(PATH_FOR_DIRS) if is_dir
  path += "#{basename}.#{DOTFILE_EXT}"
end

def switch_to_zsh
  if ENV["SHELL"] =~ /zsh/
    puts "using zsh"
  else
    print "switch to zsh? (recommended) [ynq] "
    case $stdin.gets.chomp
    when 'y'
      puts "switching to zsh"
      system %Q{chsh -s `which zsh`}
    when 'q'
      exit
    else
      puts "skipping zsh"
    end
  end
end

def install_oh_my_zsh
  if File.exist?(File.join(ENV['HOME'], "#{PATH_FOR_OH_MY_ZSH}"))
    puts "found #{ENV['HOME']}/#{PATH_FOR_OH_MY_ZSH}"
  else
    print "install oh-my-zsh? [ynq] "
    case $stdin.gets.chomp
    when 'y'
      puts "installing oh-my-zsh"
      system %Q{git clone https://github.com/robbyrussell/oh-my-zsh.git "#{ENV['HOME']}/#{PATH_FOR_OH_MY_ZSH}"}
    when 'q'
      exit
    else
      puts "skipping oh-my-zsh, you will need to change #{ENV['HOME']}/.zshrc"
    end
  end
end
