# Dotfiles

These dotfiles are configuration files, wich I use. There are more in my home directory, but I don't like to publish
these, because they contain sensitive data.

If you want to see some more, please contact me.

Autor: @DSIW

E-Mail: dsiw@dsiw-it.de

Repository: https://github.com/DSIW/dotfiles

## Rake Tasks

* `add[glob]` - Add files to dotfiles repository.

Example:

    rake add["~/.*[^~]"]

* `init_zsh` - Switch to ZSH (install unless exists)
* `install` - Hook our dotfiles into system-standard positions.
* `install_bin` - Install script to bin (beta)
* `list` - list tasks
* `uninstall` - Delete all symlinked files from home dir.

_The Rakefile is created of other Rakefiles:_

* [holman/dotfiles](https://github.com/DSIW/dotfiles/blob/master/Rakefile)
* [ryanb/dotfiles](https://github.com/ryanb/dotfiles/blob/master/Rakefile)
* [lucapette/dotfiles](https://github.com/lucapette/dotfiles/blob/master/Rakefile)

