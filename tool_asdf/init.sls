# -*- coding: utf-8 -*-
# vim: ft=sls

{#- Get the `tplroot` from `tpldir` #}
{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as asdf with context %}

include:
  - .package
{%- if asdf.users | rejectattr('xdg', 'sameas', False) | list %}
  - .xdg
{%- endif %}
{%- if asdf.users | selectattr('dotconfig', 'defined') | selectattr('dotconfig') | list %}
  - .configsync
{%- endif %}
{%- for tool in asdf.lookup.available_tools %}
  {%- if asdf.users | selectattr('asdf.' ~ tool, 'defined') | list %}
  - .{{ tool }}
  {%- endif %}
{%- endfor %}
{%- if asdf.users | selectattr('asdf.system', 'defined') | list %}
  - .system
{%- endif %}
