# -*- coding: utf-8 -*-
# vim: ft=sls

{#- Get the `tplroot` from `tpldir` #}
{%- set tplroot = tpldir.split('/')[0] %}
{%- set sls_package_install = tplroot ~ '.package.install' %}
{%- from tplroot ~ "/map.jinja" import mapdata as asdf with context %}

include:
  - {{ sls_package_install }}


{#- Homebrew manages the completions already. #}
{%- if 'Darwin' != grains.kernel %}
{%-   for user in asdf.users | selectattr('completions', 'defined') | selectattr('completions') %}

Completions directory for asdf is available for user '{{ user.name }}':
  file.directory:
    - name: {{ user.home | path_join(user.completions) }}
    - user: {{ user.name }}
    - group: {{ user.group }}
    - mode: '0700'
    - makedirs: true

# This only considers zsh atm. @TODO other shells
asdf shell completions are available for user '{{ user.name }}':
  file.copy:
    - name: {{ user.home | path_join(user.completions, '_asdf') }}
    - source: {{ asdf.lookup.paths.install_dir | path_join('completions', '_asdf') }}
    - onchanges:
      - asdf is installed
    - require:
      - asdf is installed
      - Completions directory for asdf is available for user '{{ user.name }}'
{%-   endfor %}
{%- endif %}
