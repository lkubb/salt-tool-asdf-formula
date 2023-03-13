# -*- coding: utf-8 -*-
# vim: ft=sls

{%- set tplroot = tpldir.split('/')[0] %}
{%- set sls_deps = [] %}
{%- from tplroot ~ "/map.jinja" import mapdata as asdf with context %}

{%- for tool in asdf.lookup.available_tools %}
{%-   if asdf.users | selectattr("asdf.system." ~ tool, "defined") | list %}
{%-     do sls_deps.append(tplroot ~ "." ~ tool) %}
{%-   endif %}
{%- endfor %}

include: {{ sls_deps | json }}

{%- for user in asdf.users | selectattr('asdf.system', 'defined') %}
{%-   for tool, version in user.asdf.system.items() %}

User '{{ user.name }}' system default {{ tool }} {{ version }} is installed:
  asdf.version_installed:
    - name: {{ tool }}
    - version: '{{ version }}'
    - user: {{ user.name }}
    - require:
      - asdf setup is completed
      - sls: {{ tplroot ~ "." ~ tool ~ ".package" }}

User '{{ user.name }}' uses {{ tool }} {{ version }} by default:
  asdf.version_set:
    - name: {{ tool }}
    - version: '{{ version }}'
    - user: {{ user.name }}
    - require:
      - User '{{ user.name }}' system default {{ tool }} {{ version }} is installed
    # Sometimes, the freshly installed version is not immediately listed
    - retry:
        attempts: 5
        interval: 2
{%-   endfor %}
{%- endfor %}
