# -*- coding: utf-8 -*-
# vim: ft=sls

{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/ruby/map.jinja" import dependencies, users %}

include:
  - {{ tplroot }}.package
  - .deps

{%- for user in users %}

Ruby plugin is up to date for user '{{ user.name }}':
  asdf.plugin_latest:
    - name: ruby
    - user: {{ user.name }}

  {%- for version in user.asdf.ruby %}

Ruby {{ version }} is installed for user '{{ user.name }}':
  asdf.version_installed:
    - name: ruby
    - version: {{ version }}
    - user: {{ user.name }}
    - require:
      - asdf setup is completed
      - Required packages for compiling Ruby are available
  {%- endfor %}
{%- endfor %}
