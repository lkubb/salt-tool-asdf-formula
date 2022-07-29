# -*- coding: utf-8 -*-
# vim: ft=sls

{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as asdf with context %}

include:
  - {{ tplroot }}.package


{%- for user in asdf.users | rejectattr('xdg', 'sameas', false) %}

{%-   set user_default_conf = user.home | path_join(asdf.lookup.paths.confdir, asdf.lookup.paths.conffile) %}
{%-   set user_default_datadir = user.home | path_join(asdf.lookup.paths.datadir) %}
{%-   set user_default_versions = user.home | path_join(asdf.lookup.paths.confdir, asdf.lookup.paths.versionfile) %}
{%-   set user_xdg_confdir = user.xdg.config | path_join(asdf.lookup.paths.xdg_dirname) %}
{%-   set user_xdg_conffile = user_xdg_confdir | path_join(asdf.lookup.paths.xdg_conffile) %}
{%-   set user_xdg_datadir = user.xdg.data | path_join(asdf.lookup.paths.xdg_dirname) %}
{%-   set user_xdg_versionfile = user_xdg_confdir | path_join(asdf.lookup.paths.xdg_versionfile) %}

# workaround for file.rename not supporting user/group/mode for makedirs
asdf has its config dir in XDG_CONFIG_HOME for user '{{ user.name }}':
  file.directory:
    - name: {{ user_xdg_confdir }}
    - user: {{ user.name }}
    - group: {{ user.group }}
    - mode: '0700'
    - makedirs: true

Existing asdf configuration is migrated for user '{{ user.name }}':
  file.rename:
    - names:
      - {{ user_xdg_conffile }}:
        - source: {{ user_default_conf }}
      - {{ user_xdg_versionfile }}:
        - source: {{ user_default_versions }}
    - require:
      - asdf has its config dir in XDG_CONFIG_HOME for user '{{ user.name }}'
    - require_in:
      - asdf setup is completed

asdf has its config file in XDG_CONFIG_HOME for user '{{ user.name }}':
  file.managed:
    - name: {{ user_xdg_conffile }}
    - user: {{ user.name }}
    - group: {{ user.group }}
    - replace: false
    - makedirs: true
    - mode: '0600'
    - dir_mode: '0700'
    - require:
      - Existing asdf configuration is migrated for user '{{ user.name }}'
    - require_in:
      - asdf setup is completed

# workaround for file.rename not supporting user/group/mode for makedirs
XDG_DATA_HOME exists for asdf for user '{{ user.name }}':
  file.directory:
    - name: {{ user.xdg.data }}
    - user: {{ user.name }}
    - group: {{ user.group }}
    - mode: '0700'
    - makedirs: true

Existing asdf data is migrated for user '{{ user.name }}':
  file.rename:
    - name: {{ user_xdg_datadir }}
    - source: {{ user_default_datadir }}
    - require_in:
      - asdf setup is completed

# @FIXME
# This actually does not make sense and might be harmful:
# Each file is executed for all users, thus this breaks
# when more than one is defined!
asdf uses XDG dirs during this salt run:
  environ.setenv:
    - value:
        ASDF_CONFIG_FILE: "{{ user_xdg_conffile }}"
        ASDF_DATA_DIR: "{{ user_xdg_datadir }}"
        ASDF_DEFAULT_TOOL_VERSIONS_FILENAME: "{{ user_xdg_versionfile }}"
    - require_in:
      - asdf setup is completed
      - asdf is reshimmed on xdg migration for user '{{ user.name }}'

{%-   if user.get('persistenv') %}

persistenv file for asdf exists for user '{{ user.name }}':
  file.managed:
    - name: {{ user.home | path_join(user.persistenv) }}
    - user: {{ user.name }}
    - group: {{ user.group }}
    - replace: false
    - mode: '0600'
    - dir_mode: '0700'
    - makedirs: true

asdf knows about XDG location for user '{{ user.name }}':
  file.append:
    - name: {{ user.home | path_join(user.persistenv) }}
    - text: |
        export ASDF_CONFIG_FILE="${XDG_CONFIG_HOME:-$HOME/.config}/{{ asdf.lookup.paths.xdg_dirname | path_join(asdf.lookup.paths.xdg_conffile) }}"
        export ASDF_DATA_DIR="${XDG_DATA_HOME:-$HOME/.local/share}/{{ asdf.lookup.paths.xdg_dirname }}"
        export ASDF_DEFAULT_TOOL_VERSIONS_FILENAME="${XDG_CONFIG_HOME:-$HOME/.config}/{{ asdf.lookup.paths.xdg_dirname |
                path_join(asdf.lookup.paths.xdg_versionfile) }}"
    - require:
      - persistenv file for asdf exists for user '{{ user.name }}'
    - require_in:
      - asdf setup is completed
      - asdf is reshimmed on xdg migration for user '{{ user.name }}'
{%-   endif %}

asdf is reshimmed on xdg migration for user '{{ user.name }}':
  cmd.run:
    - name: asdf reshim
    - runas: {{ user.name }}
    - onchanges:
      - Existing asdf data is migrated for user '{{ user.name }}'
{%- endfor %}
