# `asdf` Formula
Sets up, configures and updates `asdf` version manager and some selected tools for development environments.

## Usage
Applying `tool-asdf` will make sure `asdf` and its managed packages are configured as specified.

## Configuration
### Pillar
#### General `tool` architecture
Since installing user environments is not the primary use case for saltstack, the architecture is currently a bit awkward. All `tool` formulas assume running as root. There are three scopes of configuration:
1. per-user `tool`-specific
  > e.g. generally force usage of XDG dirs in `tool` formulas for this user
2. per-user formula-specific
  > e.g. setup this tool with the following configuration values for this user
3. global formula-specific (All formulas will accept `defaults` for `users:username:formula` default values in this scope as well.)
  > e.g. setup system-wide configuration files like this

**3** goes into `tool:formula` (e.g. `tool:git`). Both user scopes (**1**+**2**) are mixed per user in `users`. `users` can be defined in `tool:users` and/or `tool:formula:users`, the latter taking precedence. (**1**) is namespaced directly under `username`, (**2**) is namespaced under `username: {formula: {}}`.

```yaml
tool:
######### user-scope 1+2 #########
  users:                         #
    username:                    #
      xdg: true                  #
      dotconfig: true            #
      formula:                   #
        config: value            #
####### user-scope 1+2 end #######
  formula:
    formulaspecificstuff:
      conf: val
    defaults:
      yetanotherconfig: somevalue
######### user-scope 1+2 #########
    users:                       #
      username:                  #
        xdg: false               #
        formula:                 #
          otherconfig: otherval  #
####### user-scope 1+2 end #######
```

#### User-specific
The following shows an example of `tool-asdf` pillar configuration. Namespace it to `tool:users` and/or `tool:asdf:users`.
```yaml
user:
  xdg: true                         # force xdg dirs
  dotconfig: true                   # sync this user's config from a dotfiles repo available as salt://dotconfig/<user>/asdf or salt://dotconfig/asdf
  persistenv: '.config/zsh/zshenv'  # persist asdf env vars to use xdg dirs permanently (will be appended to file relative to $HOME)
  rchook: '.config/zsh/zshrc'       # runcom that loads hooks, if you want to autoconfigure your shell (eg for direnv)
  asdf:
    update_auto: true               # keep plugins updated to latest version on subsequent runs
    python: latest                  # plugin: version to install. can be True (for latest), list or string
    integrate-direnv: true          # if direnv is installed, make sure envrc files can use asdf
    system:                         # user-specific default of global tool version
      python: latest
```

#### Formula-specific
```yaml
tool:
  asdf:
    update_auto: true               # keep asdf and plugin dependencies updated to latest version on
                                    # subsequent runs (for Linux, brew does that anyways)
    defaults:                       # default asdf config values for users go here
      python: 3.10.1
```

## Todo
- generalize plugins to definitions to avoid repetition. maybe like that:
```yaml
python:
  dependencies:
    - list
    - of
    - pkgs
  xdg_vars:
    config:
      - GIMME_BLOODY_XDG_YO: .default-stuff
```
