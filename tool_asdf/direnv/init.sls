# -*- coding: utf-8 -*-
# vim: ft=sls

{#- Get the `tplroot` from `tpldir` #}
{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as asdf with context %}

{%- set users = asdf.users | selectattr('asdf.direnv', 'defined') | list -%} {# casting to list ensures it can be imported #}

include:
  - .package
{%- if users | selectattr('rchook', 'defined') | list %}
  - .hook
{%- endif %}
{%- if users | selectattr('asdf.integrate-direnv', 'defined') | selectattr('asdf.integrate-direnv') | list %}
  - .integrate
{%- endif %}