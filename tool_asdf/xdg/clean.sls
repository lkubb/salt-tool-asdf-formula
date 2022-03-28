# -*- coding: utf-8 -*-
# vim: ft=sls

{#- Get the `tplroot` from `tpldir` #}
{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as asdf with context %}

{%- for user in asdf.users | rejectattr('xdg', 'sameas', False) %}

asdf configuration is cluttering $HOME for user '{{ user.name }}':
  file.rename:
    - names:
      - {{ user.home }}/.tool-versions:
        - source: {{ user.xdg.config }}/asdf/tool-versions
        - onlyif:
          - test -e {{ user.xdg.config }}/asdf/tool-versions
      - {{ user.home }}/.asdfrc:
        - source: {{ user.xdg.config }}/asdf/asdfrc
        - onlyif:
          - test -e {{ user.xdg.config }}/asdf/tool-versions

asdf data is cluttering $HOME for user '{{ user.name }}':
  file.rename:
    - name: {{ user.home }}/.asdf
    - source: {{ user.xdg.data }}/asdf
    - onlyif:
      - test -d {{ user.xdg.data }}/asdf

asdf does not use XDG dirs during this salt run:
  environ.setenv:
    - value:
        ASDF_CONFIG_FILE: false
        ASDF_DATA_DIR: false
        ASDF_DEFAULT_TOOL_VERSIONS_FILENAME: false
    - false_unsets: true

  {%- if user.get('persistenv') %}

asdf is ignorant about XDG config for user '{{ user.name }}':
  file.replace:
    - name: {{ user.home }}/{{ user.persistenv }}
    - pattern: {{ 'export ASDF_CONFIG_FILE="${XDG_CONFIG_HOME:-$HOME/.config}/asdf/asdfrc"' | regex_escape }}
    - repl: ''

asdf is ignorant about XDG config for tool versions for user '{{ user.name }}':
  file.replace:
    - name: {{ user.home }}/{{ user.persistenv }}
    - pattern: {{ 'export ASDF_DEFAULT_TOOL_VERSIONS_FILENAME="${XDG_CONFIG_HOME:-$HOME/.config}/asdf/tool-versions"' | regex_escape }}
    - repl: ''

asdf is ignorant about XDG data for user '{{ user.name }}':
  file.replace:
    - name: {{ user.home }}/{{ user.persistenv }}
    - pattern: {{ 'export ASDF_DATA_DIR="${XDG_DATA_HOME:-$HOME/.local/share}/asdf"' | regex_escape }}
    - repl: ''
  {%- endif %}
{%- endfor %}
