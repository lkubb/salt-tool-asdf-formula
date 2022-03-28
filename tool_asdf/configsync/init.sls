# -*- coding: utf-8 -*-
# vim: ft=sls

{#- Get the `tplroot` from `tpldir` #}
{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as asdf with context %}
{%- from tplroot ~ "/libtofs.jinja" import files_switch %}

include:
  - {{ tplroot }}.package

{%- for user in asdf.users | selectattr('dotconfig', 'defined') | selectattr('dotconfig') %}
  {%- set dotconfig = user.dotconfig if dotconfig is mapping else {} %}

asdf configuration is synced for user '{{ user.name }}':
  file.recurse:
    - name: {{ user._asdf.confdir }}
    - source: {{ files_switch(
                [salt['file.join']('user', user.name, tplroot[5:])],
                default_files_switch=['id', 'os', 'os_family'],
                override_root='dotconfig') }}
              {{ files_switch(
                [tplroot[5:]],
                default_files_switch=['id', 'os', 'os_family'],
                override_root='dotconfig') }}
    - context:
        user: {{ user | json }}
    - template: jinja
    - user: {{ user.name }}
    - group: {{ user.group }}
  {%- if dotconfig.get('file_mode') %}
    - file_mode: '{{ dotconfig.file_mode }}'
  {%- endif %}
    - dir_mode: '{{ dotconfig.get('dir_mode', '0700') }}'
    - clean: {{ dotconfig.get('clean', False) | to_bool }}
    - makedirs: True
    - require_in:
      - asdf setup is completed
{%- endfor %}
