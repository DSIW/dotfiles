require 'rake'
require 'pathname'
require 'erb'
require 'yaml/store'

begin
  if require 'colorize'
    COLORS = true
  end
rescue Exception => e
  COLORS = false
end

DEBUG                       = false
DOTFILE_EXT                 = "symlink"
ERB_EXT                     = "erb"
BACKUP_EXT                  = "bak"
REPO                        = File.join(ENV['HOME'], ".dotfiles")
CONFIG_FILE                 = ".dotrc"
PATH_FOR_DIRS               = ""
PATH_FOR_BINS               = "_bin"
PATH_FOR_OH_MY_ZSH          = ".oh-my-zsh"
CONFIG                      = YAML::Store.new File.join(REPO, CONFIG_FILE)
LINK_OPTIONS                = [:skip,:skip_all,:overwrite,:overwrite_all,:backup,:backup_all]
CONFIG_OPTIONS              = [:abort,:overwrite]
DEFAULT_IGNORE_FILES        = [
  ".git",
  ".gitmodules",
  ".gitignore",
  "Rakefile",
  "README",
]
DEFAULT_ANSWERS             = {
  :skip          => false,
  :skip_all      => false,
  :overwrite     => false,
  :overwrite_all => false,
  :backup        => false,
  :backup_all    => false
}

module TaskMethods
  def task_add args
    expanded_glob = File.expand_path(args[:glob])
    remove_pseudo_dirs(expanded_glob).each do |filename|

      if !File.file?(filename) && !File.directory?(filename)
        puts colorize_if_installed("File #{filename} isn't a file or directory.", :red)
        next
      end
      if File.symlink?(filename)
        puts colorize_if_installed("File #{filename} is already a symlink.", :red)
        next
      end

      if File.dirname(filename).include? REPO
        puts colorize_if_installed("File '#{filename}' does already exist in repository (#{REPO}).", :red)
        next
      end
      target = dotfile_of(filename)
      expanded_target = File.join(REPO, target)
      FileUtils.mv(filename, expanded_target, :verbose => true, :noop => DEBUG)
      link_files [expanded_target]
    end
  end

  def task_dotfiles
    files = dotfiles
    puts "Rake is managing #{colorize_if_installed files.count, :green} files:"
    puts ""
    files.each do |dotfile|
      puts "  #{colorize_if_installed "*", :green} #{dotfile.gsub(REPO+'/', '')}"
    end
  end

  def task_install_bin
    bins = Dir["#{REPO}/#{PATH_FOR_BINS}/*"]
    puts "No binaries!" if BINS.empty?
    bins.each do |file|
      target_file = File.join(target_dir, 'sys', 'bin', Pathname.new(file).basename)
      FileUtils.cp file, target_file, :preserve => true, :verbose => true, :noop => DEBUG
      puts "Installed #{file} to #{target_file}"
    end
  end

  def task_uninstall
    uninstall dotfile_targets
  end

  def task_setup
    FileUtils.mkdir_p REPO
    answer = ask colorize_if_installed("File already exists: #{CONFIG_FILE}, what do you want to do?", :red), :answers => CONFIG_OPTIONS
    if answer == :overwrite
      CONFIG.transaction do
        CONFIG["ignore"] = DEFAULT_IGNORE_FILES.map(&:to_s)
      end
    end
  end

  def task_install
    link_files dotfiles
  end

  def task_remove args
    # TODO
    expanded_glob = File.expand_path(args[:glob])
    file_is_in_repo = File.dirname(expanded_glob).include? REPO
    source = file_is_in_repo ? target_of(expanded_glob) : dotfile_of(expanded_glob)
    target = file_is_in_repo ? dotfile_of(expanded_glob) : target_of(expanded_glob)
    FileUtils.copy_file source, target, :noop => DEBUG
  end

  def task_sync
    task_uninstall
    task_install
  end
end
include TaskMethods

module Util
  module Dotfile
    def rm_erb_ext file
      file.sub(/\.#{ERB_EXT}$/, '')
    end

    def rm_basename_ext file
      path = Pathname.new(file)
      path.basename.sub(/\.(#{DOTFILE_EXT}|#{ERB_EXT})$/, '').to_s
    end

    def target_of file, options={:remove_dot => true}
      basename = rm_basename_ext(file)
      basename = basename[1..-1] if options[:remove_dot] && basename.start_with?(".") # removes first "."
      File.join(ENV["HOME"], ".#{basename}")
    end

    def backup_of file, options={:remove_dot => true}
      File.join(ENV['HOME'], "#{options[:remove_dot] ? '' : '.'}#{rm_basename_ext(file)}.#{BACKUP_EXT}")
    end

    # Examples:
    # * .../file -> ~/.dotfiles/file.symlink
    # * .../dir  -> ~/.dotfiles/PATH_FOR_DIRS/dir.symlink
    def dotfile_of file
      is_dir = File.directory? file

      basename = rm_basename_ext file
      basename = basename[1..-1] if basename.start_with? "." # remove first "."

      path = Pathname.new(".") # like empty pathname
      path += Pathname.new(PATH_FOR_DIRS) if is_dir
      path += "#{basename}.#{DOTFILE_EXT}"
    end

    def dotfiles
      files = Dir["#{REPO}/**/*.{#{DOTFILE_EXT},#{ERB_EXT}}"]
      ignore_files = []
      CONFIG.transaction { ignore_files = CONFIG["ignore"] }
      files.reject! { |f| ignore_files.any? { |re| f.match(/#{re}\//) } }
        if block_given?
          files.each { |file| yield file }
        end
      files
    end

    def dotfile_targets
      files = dotfiles.map { |dotfile| target_of(dotfile) }
      if block_given?
        files.each { |file| yield file }
      end
      files
    end
  end
  include Dotfile

  module DotfileUtils
    def replace_file file
      FileUtils.rm_rf target_of(file), :noop => DEBUG
      link_file file
    end

    def link_file file
      target = target_of file
      if file =~ /.#{ERB_EXT}$/
        generate_file file, :noop => DEBUG
      else
        puts "linking to #{target}"
        FileUtils.ln_s(file, target, :verbose => false, :noop => DEBUG)
      end
    end

    def link_files dotfiles
      answers = DEFAULT_ANSWERS

      dotfiles.each do |dotfile|
        update_answers! answers
        target = target_of dotfile

        if File.exists?(target) || File.symlink?(target)
          unless answers[:skip_all] || answers[:overwrite_all] || answers[:backup_all]
            answer = ask_linking dotfile
            answers[answer] = true
            next if answers[:skip]
          end
        end
        FileUtils.rm_rf(target, :noop => DEBUG) if answers[:overwrite] || answers[:overwrite_all]
        backup_file dotfile if answers[:backup] || answers[:backup_all]

        if !answers[:skip_all] || !File.exist?(target)
          link_file dotfile
        end
      end
    end

    def generate_file file, options={}
      target = target_of file
      puts "generating #{target}"
      return if options[:noop]

      File.open(target, 'w') do |new_file|
        CONFIG.transaction do
          new_file.write ERB.new(File.read(file)).result(binding)
        end
      end
    rescue Interrupt
    end

    def backup_file file
      src_file    = target_of(file, :remove_dot => false)
      backup_file = backup_of(file, :remove_dot => false)
      puts "backup to #{backup_file}"

      if File.directory? file
        FileUtils.cp_r(src_file, backup_file, :noop => DEBUG)
      else
        FileUtils.cp(src_file, backup_file, :noop => DEBUG)
      end
    end

    def restore_file file
      backup_file = backup_of(file)
      orig_file   = target_of(file, :remove_dot => false)
      puts "restore #{backup_file}"
      FileUtils.mv(backup_file, orig_file, :verbose => true, :noop => DEBUG)
    end

    def rm_backup_file file
      backup = backup_of file
      puts "rm backup #{backup}"
      FileUtils.rm_f(file, :noop => DEBUG)
    end
  end
  include DotfileUtils

  module ZSH
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
  end
  include ZSH

  module HumanInteraction
    def colorize_if_installed string, color
      string = string.to_s unless string.is_a? String
      COLORS ? string.colorize(color) : string
    end

    def ask msg, options={}
      if options[:answers]
        answers = options[:answers].reduce({}) { |hash,key| hash.merge({key => true}) } # first_key => true,...
        options.merge! answers do |key, old, new|
          old && new
        end
        options.delete(:answers)
      end
      options = options.select { |k,v| v }.keys # select all keys if true

      hash = options.reduce({}) do |hash, sym|
        indicator = sym.to_s[0]
        indicator.upcase! if sym.to_s.end_with? "all"
        hash.merge({indicator.to_sym => sym})
      end

      options_str = hash.map { |indicator, opt|
        desc = opt.to_s[1..-1]
        desc = desc.gsub('_', ' ') if opt.to_s.end_with? "all"
        "[#{colorize_if_installed(indicator, :blue)}]#{desc}"
      }.join(", ")

      puts "#{msg} #{options_str}"

      answer = STDIN.gets.chomp
      hash[answer.to_sym] || ask(file, options)
    end

    def ask_linking dotfile
      ask colorize_if_installed("File already exists: #{target_of(dotfile)}, what do you want to do?", :red), :answers => LINK_OPTIONS
    end

    def update_answers! answers
      no_globals = answers.keys.select { |a| !a.to_s.end_with? "all" }
      no_globals.each { |a| answers[a] = false }
    end

    def gets msg
      print(msg)
      STDOUT.flush
      STDIN.gets.chomp
    end
  end
  include HumanInteraction

  def remove_pseudo_dirs glob
    dirname = Pathname.new(glob).dirname
    pseudo_dirs = %w[. ..]
    pseudo_with_path = pseudo_dirs.map {|file| File.join(File.expand_path(dirname), file)}
    Dir[glob] - pseudo_with_path
  end

  def uninstall targets
    targets.each do |target|
      # Remove all symlinks created during installation
      if File.symlink? target
        FileUtils.rm target, :verbose => true, :noop => DEBUG
      end

      # Replace any backups made during installation
      if File.exists? "#{target}.#{BACKUP_EXT}"
        restore_file target
      end
    end
  end
end
include Util

def create_task(*args, &block)
  default_options = {
    :desc => "",
    :after_message => "Done.",
  }

  task_args = [args[0]]
  options_index = 1
  if block_given?
    task_args << args[1]
    options_index = 2
  end
  options = default_options.merge(args[options_index])

  desc options[:desc].to_s
  task *task_args do |t, args|
    if block_given?
      yield t, args
    else
      send("task_#{t}".to_sym)
    end
    puts colorize_if_installed(options[:after_message], :green)
  end
end

create_task :install,     desc: "Hook our dotfiles into system-standard positions."
create_task :setup,       desc: "Setup your .dotfiles directory"
create_task :install_bin, desc: "Install script to bin"
create_task :uninstall,   desc: "Delete all symlinked files from home dir. Restores backup if exists"
create_task :dotfiles,    desc: "List your dotfiles"
create_task :sync,        desc: "Sync dotfiles with filesystem"

create_task :add, :glob, desc: "Add files to dotfiles repository. (e.g. glob: ~/.*[^~])" do |t, args|
  task_add args
end
create_task :remove, :glob, desc: "Remove files from dotfiles repository. (e.g. glob: ~/.*[^~])" do |t, args|
  task_remove args
end
create_task :update, :glob, desc: "Update all dotfiles and sync them" do |t, args|
  task_remove args
end

desc "Information about this Rakefile"
task :info do
  msg = colorize_if_installed("You#{COLORS ? "" : " don't"} have installed the gem 'colorize'!", :green)
  puts <<-EOM
Author: DSIW (dsiw@dsiw-it.de)
Repository: https://github.com/DSIW/dotfiles

#{msg}

Thanks for using and have fun.
  EOM
end

task :update do
  puts `git pull --rebase origin master`
  puts `git submodule update --recursive --rebase --init`
  puts `git push`
  task_sync
  puts colorize_if_installed("Done.", :green)
end

desc "list tasks"
task :list do
  tasks = Rake::Task.tasks - [Rake::Task[:list]]
  tasks = tasks.map(&:to_s).map(&:blue) if COLORS
  puts "Tasks: #{tasks.join(', ')}"
  puts "(type rake -T for more detail)"
end

desc "Switch to ZSH (install unless exists)"
task :init_zsh do
  install_oh_my_zsh
  switch_to_zsh
  puts colorize_if_installed("Done.", :green)
end

desc "Init VIM with Vundle"
task :init_vim do
  puts "Installing Vundle"
  puts `git clone http://github.com/gmarik/vundle.git "#{ENV['HOME']}/.dotfiles/vim.symlink/bundle/vundle"`
  puts "Please run 'vim +BundleInstall! +BundleClean +q' to get bundles"
  puts colorize_if_installed("Done.", :green)
end

task :default => ['list']
