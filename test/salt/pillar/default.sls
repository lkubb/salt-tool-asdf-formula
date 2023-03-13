# -*- coding: utf-8 -*-
# vim: ft=yaml
---
tool_global:
  users:
    user:
      completions: .completions
      configsync: true
      persistenv: .bash_profile
      rchook: .bashrc
      xdg: true
      asdf:
        direnv: 2.30.3
        golang: latest
        integrate_direnv: true
        nodejs: 17.8.0
        php: 8.1.4
        python: 3.10.3
        ruby: 3.1.0
        rust: latest
        system:
          python: 3.10.3
        update_auto: true
tool_asdf:
  lookup:
    master: template-master
    # Just for testing purposes
    winner: lookup
    added_in_lookup: lookup_value

    pkg:
      name: asdf
    paths:
      confdir: ''
      conffile: '.asdfrc'
      xdg_dirname: 'asdf'
      xdg_conffile: 'asdfrc'
    rootgroup: root
    available_tools:
      - direnv
      - golang
      - nodejs
      - php
      - python
      - ruby
      - rust
    direnv_paths:
      confdir: .config/direnv
      conffile: direnvrc
      xdg_conffile: direnvrc
      xdg_dirname: direnv
    golang_paths:
      confdir: ''
      conffile: .default-golang-packages
      xdg_conffile: default-golang-packages
    nodejs_paths:
      confdir: ''
      conffile: .default-npm-packages
      xdg_conffile: default-npm-packages
    python_paths:
      confdir: ''
      conffile: .default-python-packages
      xdg_conffile: default-python-packages
    ruby_paths:
      confdir: ''
      conffile: .default-gems
      xdg_conffile: default-gems
    rust_paths:
      confdir: ''
      conffile: .default-cargo-crates
      xdg_conffile: .default-cargo-crates

  tofs:
    # The files_switch key serves as a selector for alternative
    # directories under the formula files directory. See TOFS pattern
    # doc for more info.
    # Note: Any value not evaluated by `config.get` will be used literally.
    # This can be used to set custom paths, as many levels deep as required.
    files_switch:
      - any/path/can/be/used/here
      - id
      - roles
      - osfinger
      - os
      - os_family
    # All aspects of path/file resolution are customisable using the options below.
    # This is unnecessary in most cases; there are sensible defaults.
    # Default path: salt://< path_prefix >/< dirs.files >/< dirs.default >
    #         I.e.: salt://tool_asdf/files/default
    # path_prefix: template_alt
    # dirs:
    #   files: files_alt
    #   default: default_alt
    # The entries under `source_files` are prepended to the default source files
    # given for the state
    # source_files:
    #   tool-asdf-config-file-file-managed:
    #     - 'example_alt.tmpl'
    #     - 'example_alt.tmpl.jinja'

  # Just for testing purposes
  winner: pillar
  added_in_pillar: pillar_value
