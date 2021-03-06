### DevKit
Devkit is a Command Line tool to easily manage SSH Identities and Github Identitites. It provides an easy way to manage your whole team credentials along with a way to add/remove developers, show status of current developer and switch between developer identities. 

### Installation

If you are using bundler to manage your gems, add dependency to your Gemfile.

```
$ gem install devkit
```

### Usage

```
Usage: devkit [options] nick_name

Devkit specific options:
General options:
    -i, --init                       Intializing devkit, creating .devkit file
    -f, --fetch url                  Fetch .devkit config and ssh identities (private keys) from a remote URL.
    -l, --list                       Shows list of identities
    -p, --purge                      Removes all devkit generated files
    -s, --status                     Shows current identity
    -r, --remove nick_name           Removes identity from .devkit file
    -c, --choose nick_name           Switches the identity
    -a, --add                        Adding a new identity to .devkit file
    -d, --drop                       Drop existing identities
    -h, --help                       Show this message
    -v, --version                    Show version
```

#### Notes on "Fetch" functionality

The fetch option allows you to maintain a centralised config for your development team - this is useful if your team are moving from machine to machine. Specify the URL of the devkit file and it will download and save it to your home directory as .devkit. It will also iterate through all identities and try to download them from the same HTTP directory.

**It's of critical importance that any ssh identities shared in this way are passphrase protected**

### Credits

### Maintainers

[Srinivas Aki](http://github.com/saki), The Egghead Creative

### License

Copyright (c) 2013-2016 The Egghead Creative. This software is licensed under the MIT License.
