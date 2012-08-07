# Dotfiles

These dotfiles are configuration files, which I use. There are more in my home directory, but I don't like to publish
these, because they contain sensitive information.

If you want to see any more, please contact me.

Author: [DSIW](https://github.com/DSIW)

E-Mail: dsiw@dsiw-it.de

Repository: [DSIW/dotfiles](https://github.com/DSIW/dotfiles)

## Dependencies

* [colorize](https://rubygems.org/gems/colorize) (optional)

## Installation

``` sh
git clone --recurse-submodules https://github.com/DSIW/dotfiles.git ~/.dotfiles
```

## Rake Tasks

* `rake add[glob]` – Add files to dotfiles repository.

``` ruby
rake add["~/.*[^~]"]
```

* `rake dotfiles` – List your dotfiles

```
Rake is managing 17 files:

  * vim.symlink
  * vim.symlink/vimrc.symlink
  * vim.symlink/gvimrc.symlink
  * git.symlink
  * oh-my-zsh.symlink
  * gemrc.symlink
  * zsh.symlink/zshrc.symlink
  * zsh.symlink/aliasrc.symlink
  * urlview.symlink
  * git.symlink/gitconfig.erb
...
```

* `rake info` – Information about this Rakefile

```
Author: DSIW (dsiw@dsiw-it.de)
Repository: https://github.com/DSIW/dotfiles

You have installed the gem 'colorize'!

Thanks for using and have fun.
```

* `rake init_vim` – Init VIM with Vundle
* `rake init_zsh` – Switch to ZSH (install unless exists)
* `rake install` – Hook our dotfiles into system-standard positions.

```
linking to /home/dsiw/.vim
linking to /home/dsiw/.vimrc
[...]
Done.
```

* `rake install_bin` – Install script to bin
* `rake list` – list tasks

```
Tasks: add, default, dotfiles, info, init_vim, init_zsh, install, install_bin, remove, setup, sync, uninstall, update
(type rake -T for more detail)
```

* `rake remove[glob]` – Remove files from dotfiles repository.
* `rake setup` – Setup your .dotfiles directory and will create .dotrc config file.
* `rake sync` – Sync dotfiles with filesystem

```
rm /home/dsiw/.vim
rm /home/dsiw/.vimrc
[...]
linking to /home/dsiw/.vim
linking to /home/dsiw/.vimrc
[...]
Done.
```

* `rake uninstall` – Delete all symlinked files from home dir.

```
rm /home/dsiw/.vim
rm /home/dsiw/.vimrc
[...]
Done.
```

* `rake update` – Update all dotfiles and sync them

```
<Pulling>

rm /home/dsiw/.vim
rm /home/dsiw/.vimrc
[...]
linking to /home/dsiw/.vim
linking to /home/dsiw/.vimrc
[...]
Done.
```

See `rake -T` for all available tasks.

## Sources

The Rakefile is created of these other Rakefiles and software:

* [holman/dotfiles](https://github.com/DSIW/dotfiles/blob/master/Rakefile)
* [ryanb/dotfiles](https://github.com/ryanb/dotfiles/blob/master/Rakefile)
* [lucapette/dotfiles](https://github.com/lucapette/dotfiles/blob/master/Rakefile)
* [mattdbridges/dotify](https://github.com/mattdbridges/dotify)

## Copyright / License

Copyright (c) 2012 DSIW <dsiw@dsiw-it.de>

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

## Contributing

Contributions are welcome and encouraged. The contrubution process is the typical Github one.

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new [Pull Request](https://github.com/mattdbridges/dotify/pull/new/master)
