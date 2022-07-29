# -*- coding: utf-8 -*-
# vim: ft=sls

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

# might not be necessary
{%- for user in asdf.users %}

asdf is reshimmed on version change:
  cmd.run:
    - name: asdf reshim
    - runas: {{ user }}
    - onchanges:
      - asdf is installed
{%- endfor %}
