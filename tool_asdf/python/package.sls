# -*- coding: utf-8 -*-
# vim: ft=sls

{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/python/map.jinja" import users %}

include:
  - {{ tplroot }}.package
  - .deps

{%- for user in users %}

Python plugin is up to date for user '{{ user.name }}':
  asdf.plugin_latest:
    - name: python
    - user: {{ user.name }}

  {%- for version in user.asdf.python %}

Python {{ version }} is installed for user '{{ user.name }}':
  asdf.version_installed:
    - name: python
    - version: '{{ version }}'
    - user: {{ user.name }}
    - require:
      - asdf setup is completed
      - Required packages for compiling Python are available
  {%- endfor %}
{%- endfor %}
