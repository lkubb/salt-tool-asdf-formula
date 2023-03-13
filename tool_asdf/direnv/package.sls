# -*- coding: utf-8 -*-
# vim: ft=sls

{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/direnv/init.sls" import users %}

include:
  - {{ tplroot }}.package


{%- for user in users %}

Direnv plugin is up to date for user '{{ user.name }}':
  asdf.plugin_latest:
    - name: direnv
    - user: {{ user.name }}

{%-   for version in user.asdf.direnv %}

direnv {{ version }} is installed for user '{{ user.name }}':
  asdf.version_installed:
    - name: direnv
    - version: '{{ version }}'
    - user: {{ user.name }}
    - require:
      - asdf setup is completed
{%-   endfor %}
{%- endfor %}

asdf direnv setup is completed:
  test.nop
