# Dotfiles

These dotfiles are configuration files, which I use. There are more in my home directory, but I don't like to publish
these, because they contain sensitive information.

If you want to see any more, please contact me.

Author: [DSIW](https://github.com/DSIW)

E-Mail: dsiw@dsiw-it.de

Repository: [DSIW/dotfiles](https://github.com/DSIW/dotfiles)

## Rake Tasks

* `rake add[glob]` – Add files to dotfiles repository.

Example:
``` ruby
rake add["~/.*[^~]"]
```

* `rake init_vim` – Init VIM with Vundle
* `rake init_zsh` – Switch to ZSH (install unless exists)
* `rake install` – Hook our dotfiles into system-standard positions.
* `rake install_bin` – Install script to bin
* `rake list` – list tasks
* `rake sync` – Sync dotfiles with filesystem
* `rake uninstall` – Delete all symlinked files from home dir.
* `rake update` – Update all dotfiles and sync them

## Sources

The Rakefile is created of these other Rakefiles:

* [holman/dotfiles](https://github.com/DSIW/dotfiles/blob/master/Rakefile)
* [ryanb/dotfiles](https://github.com/ryanb/dotfiles/blob/master/Rakefile)
* [lucapette/dotfiles](https://github.com/lucapette/dotfiles/blob/master/Rakefile)
