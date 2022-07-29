# -*- coding: utf-8 -*-
# vim: ft=sls

{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as asdf with context %}

include:
  - .package
  - .xdg
  - .config
  - .completions
{%- for tool in asdf.lookup.available_tools %}
{%-   if asdf.users | selectattr('asdf.' ~ tool, 'defined') | list %}
  - .{{ tool }}
{%-   endif %}
{%- endfor %}
  - .system
