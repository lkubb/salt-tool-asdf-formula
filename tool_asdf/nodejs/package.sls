# -*- coding: utf-8 -*-
# vim: ft=sls

{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/nodejs/map.jinja" import users %}

include:
  - {{ tplroot }}.package
  - .deps


{%- for user in users %}
{%-   if user.asdf.get('update_auto') %}

NodeJS plugin is up to date for user '{{ user.name }}':
  asdf.plugin_latest:
    - name: nodejs
    - user: {{ user.name }}
{%-   endif %}

{%-   for version in user.asdf.nodejs %}

NodeJS {{ version }} is installed for user '{{ user.name }}':
  asdf.version_installed:
    - name: nodejs
    - version: '{{ version }}'
    - user: {{ user.name }}
    - require:
      - asdf setup is completed
      - Required packages for compiling NodeJS are available
{%-   endfor %}
{%- endfor %}
