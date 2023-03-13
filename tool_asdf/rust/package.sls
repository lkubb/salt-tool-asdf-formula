# -*- coding: utf-8 -*-
# vim: ft=sls

{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/rust/init.sls" import users %}

include:
  - {{ tplroot }}.package


# Rust plugin uses rustup and does not compile from source, so no dependencies needed
{%- for user in users %}
  {%- if user.asdf.get('update_auto') %}

Rust plugin is up to date for user '{{ user.name }}':
  asdf.plugin_latest:
    - name: rust
    - user: {{ user.name }}
  {%- endif %}

  {%- for version in user.asdf.rust %}

Rust {{ version }} is installed for user '{{ user.name }}':
  asdf.version_installed:
    - name: rust
    - version: '{{ version }}'
    - user: {{ user.name }}
    - require:
      - asdf setup is completed
  {%- endfor %}
{%- endfor %}

asdf rust setup is completed:
  test.nop
