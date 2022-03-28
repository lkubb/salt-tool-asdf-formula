# -*- coding: utf-8 -*-
# vim: ft=sls

{#- Get the `tplroot` from `tpldir` #}
{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as asdf with context %}

asdf is installed:
  pkg.installed:
    - name: {{ asdf.lookup.pkg.name }}
    - version: {{ asdf.get('version') or 'latest' }}
    {#- do not specify alternative return value to be able to unset default version #}

asdf setup is completed:
  test.nop:
    - name: Hooray, asdf setup has finished.
    - require:
      - pkg: {{ asdf.lookup.pkg.name }}
