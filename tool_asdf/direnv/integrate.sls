# -*- coding: utf-8 -*-
# vim: ft=sls

{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/direnv/init.sls" import users %}

include:
  - .package

{%- for user in users | selectattr('asdf.integrate-direnv', 'defined') | selectattr('asdf.integrate-direnv') %}

asdf direnvrc exists for user '{{ user.name }}':
  file.managed:
    - name: {{ user.xdg.config }}/direnv/direnvrc
    - user: {{ user.name }}
    - group: {{ user.group }}
    - mode: '0600'
    - dir_mode: '0700'
    - makedirs: true

asdf is integrated into direnv for '{{ user.name }}':
  file.append:
    - name: {{ user.xdg.config }}/direnv/direnvrc
    - text: source "$(asdf direnv hook asdf)"
    - require:
      - asdf direnvrc exists for user '{{ user.name }}'
    - require:
  {%- for version in user.asdf.direnv %}
      - direnv {{ version }} is installed for user '{{ user.name }}'
  {%- endfor %}
{%- endfor %}
