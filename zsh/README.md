# ZSH dot files

My personal zsh setup. It will

* Auto load ssh keys in `~.ssh/keys_auto`. For OSx it will store
  them in the `keychain`. For other systems, notably Linux, it will
  use a program `keychain` and `ssh-add` to automatically load the keys.
  Make sure `keychain` is installed. On Ubuntu something like
  `apt-get update && apt-get install keychain` will do it.
* Defines some useful aliases. Type `alias` to get a list of define aliases.
* Default editor `EDITOR` is `vim`
* Support for host and arch specific configuration.
* Files ending with `.zsh` in `~/.zsh/{default,custom,private}` will be loaded
  by `~/.zshrc` and the ones ending in `.env` by `~/.zshenv`. If load order
  is relevant within a dir the files should be prefixed with a number.
* The folders will be scannend in the following order
    * `~/.zsh/default`
    * `~/.zsh/custom`
    * `~/.zsh/custom/arch`
    * `~/.zsh/custom/host`
    * `~/.zsh/private`

Feel free to modify the dotfiles, see [Dotfiles are meant to be forked][url_holman].

[url_holman]: http://zachholman.com/2010/08/dotfiles-are-meant-to-be-forked/

# Installation
Clone the repo to your home folder and cann `install.sh`.

    $ git clone git@bitbucket.org:instilled/.zsh.git ~/.zsh
    $ cd ~/.zsh/install.sh

That's it!
