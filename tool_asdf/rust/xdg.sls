# -*- coding: utf-8 -*-
# vim: ft=sls

{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/rust/init.sls" import users %}

include:
  - .package


{%- for user in users | rejectattr('xdg', 'sameas', false) %}

asdf Rust plugin global configuration is migrated to XDG_CONFIG_HOME for user '{{ user.name }}':
  file.rename:
    - name: {{ users.xdg.config | path_join(asdf.lookup.paths.xdg_dirname, asdf.lookup.rust_paths.xdg_conffile) }}
    - source: {{ user.home | path_join(asdf.lookup.rust_paths.confdir, asdf.lookup.rust_paths.conffile) }}
    - makedirs: true
    - require_in:
{%-   for version in user.asdf.rust %}
      - Rust {{ version }} is installed for user '{{ user.name }}'
{%-   endfor %}

# rust plugin only allows to set basedir and always appends .default-cargo-crates
asdf Rust uses XDG dirs during this salt run:
  environ.setenv:
    - value:
        ASDF_CRATE_DEFAULT_PACKAGES_FILE: "{{ users.xdg.config | path_join(asdf.lookup.paths.xdg_dirname) }}"
    - require_in:
{%-   for version in user.asdf.rust %}
      - Rust {{ version }} is installed for user '{{ user.name }}'
{%-   endfor %}

{%-   if user.get('persistenv') %}

persistenv file for asdf rust for user '{{ user.name }}' exists:
  file.managed:
    - name: {{ user.home | path_join(user.persistenv) }}
    - user: {{ user.name }}
    - group: {{ user.group }}
    - replace: false
    - mode: '0600'
    - dir_mode: '0700'
    - makedirs: true

asdf Rust plugin knows about XDG location for user '{{ user.name }}':
  file.append:
    - name: {{ user.home | path_join(user.persistenv) }}
    - text: |
        export ASDF_PYTHON_DEFAULT_PACKAGES_FILE="${XDG_CONFIG_HOME:-$HOME/.config}/{{ asdf.lookup.paths.xdg_dirname }}"
    - require:
      - persistenv file for asdf rust for user '{{ user.name }}' exists
    - require_in:
{%-   for version in user.asdf.rust %}
      - Rust {{ version }} is installed for user '{{ user.name }}'
{%-   endfor %}
{%-   endif %}
{%- endfor %}
