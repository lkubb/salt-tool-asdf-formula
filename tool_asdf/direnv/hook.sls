# -*- coding: utf-8 -*-
# vim: ft=sls

{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/direnv/init.sls" import users %}
{%- from tplroot ~ "/libtofs.jinja" import files_switch %}

include:
  - {{ tplroot }}.direnv.package


{%- for user in users | selectattr('rchook', 'defined') %}

rchook for asdf direnv exists for user '{{ user.name }}':
  file.managed:
    - name: {{ user.home | path_join(user.rchook) }}
    - user: {{ user.name }}
    - group: {{ user.group }}
    - replace: false
    - mode: '0600'
    - dir_mode: '0700'
    - makedirs: true

direnv is hooked to shell for '{{ user.name }}':
  file.append:
    - name: {{ user.home | path_join(user.rchook) }}
    - source: {{ files_switch(
                ['direnv/' ~ user.shell ~ '/hook'],
                default_files_switch=['id', 'os', 'os_family']) }}
    - require:
      - sls: {{ tplroot }}.direnv.package
      - rchook for asdf direnv exists for user '{{ user.name }}'
{%- endfor %}
