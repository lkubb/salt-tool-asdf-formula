# -*- coding: utf-8 -*-
# vim: ft=sls

{#- Get the `tplroot` from `tpldir` #}
{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as asdf with context %}


{%- for user in asdf.users | rejectattr('xdg', 'sameas', false) %}

{%-   set user_default_conf = user.home | path_join(asdf.lookup.paths.confdir, asdf.lookup.paths.conffile) %}
{%-   set user_default_datadir = user.home | path_join(asdf.lookup.paths.datadir) %}
{%-   set user_default_versions = user.home | path_join(asdf.lookup.paths.confdir, asdf.lookup.paths.versionfile) %}
{%-   set user_xdg_confdir = user.xdg.config | path_join(asdf.lookup.paths.xdg_dirname) %}
{%-   set user_xdg_conffile = user_xdg_confdir | path_join(asdf.lookup.paths.xdg_conffile) %}
{%-   set user_xdg_datadir = user.xdg.data | path_join(asdf.lookup.paths.xdg_dirname) %}
{%-   set user_xdg_versionfile = user_xdg_confdir | path_join(asdf.lookup.paths.xdg_versionfile) %}


asdf configuration is cluttering $HOME for user '{{ user.name }}':
  file.rename:
    - names:
      - {{ user_default_conf }}:
        - source: {{ user_xdg_conffile }}
      - {{ user_default_versions }}:
        - source: {{ user_xdg_versionfile }}

asdf does not have its config folder in XDG_CONFIG_HOME for user '{{ user.name }}':
  file.absent:
    - name: {{ user_xdg_confdir }}
    - require:
      - asdf configuration is cluttering $HOME for user '{{ user.name }}'

asdf data is cluttering $HOME for user '{{ user.name }}':
  file.rename:
    - name: {{ user_default_datadir }}
    - source: {{ user_xdg_datadir }}

asdf does not have its data folder in XDG_CONFIG_HOME for user '{{ user.name }}':
  file.absent:
    - name: {{ user_xdg_datadir }}
    - require:
      - asdf data is cluttering $HOME for user '{{ user.name }}'

# @FIXME
# This actually does not make sense and might be harmful:
# Each file is executed for all users, thus this breaks
# when more than one is defined!
asdf does not use XDG dirs during this salt run:
  environ.setenv:
    - value:
        ASDF_CONFIG_FILE: false
        ASDF_DATA_DIR: false
        ASDF_DEFAULT_TOOL_VERSIONS_FILENAME: false
    - false_unsets: true

{%-   if user.get('persistenv') %}

asdf is ignorant about XDG config for user '{{ user.name }}':
  file.replace:
    - name: {{ user.home | path_join(user.persistenv) }}
    - pattern: {{ ('export ASDF_CONFIG_FILE="${XDG_CONFIG_HOME:-$HOME/.config}/'
                  ~ asdf.lookup.paths.xdg_dirname | path_join(asdf.lookup.paths.xdg_conffile) ~ '"')
                  | regex_escape }}
    - repl: ''

asdf is ignorant about XDG config for tool versions for user '{{ user.name }}':
  file.replace:
    - name: {{ user.home | path_join(user.persistenv) }}
    - pattern: {{ ('export ASDF_DEFAULT_TOOL_VERSIONS_FILENAME="${XDG_CONFIG_HOME:-$HOME/.config}/'
                  ~ asdf.lookup.paths.xdg_dirname | path_join(asdf.lookup.paths.xdg_versionfile) ~ '"')
                  | regex_escape }}
    - repl: ''
    - ignore_if_missing: true

asdf is ignorant about XDG data for user '{{ user.name }}':
  file.replace:
    - name: {{ user.home | path_join(user.persistenv) }}
    - pattern: {{ ('export ASDF_DATA_DIR="${XDG_DATA_HOME:-$HOME/.local/share}/"' ~ asdf.lookup.paths.xdg_dirname) | regex_escape }}
    - repl: ''
    - ignore_if_missing: true
{%-   endif %}
{%- endfor %}
