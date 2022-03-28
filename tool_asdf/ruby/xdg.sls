# -*- coding: utf-8 -*-
# vim: ft=sls

{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/ruby/map.jinja" import users %}

include:
  - .package

{%- for user in users %}
asdf ruby plugin global configuration is migrated to XDG_CONFIG_HOME for user '{{ user.name }}':
  file.rename:
    - name: {{ user.xdg.config }}/asdf/default-gems
    - source: {{ user.home }}/.default-gems
    - makedirs: true
    - onlyif:
      - test -e {{ user.home }}/.default-gems
    - require_in:
  {%- for version in user.asdf.ruby %}
      - Ruby {{ version }} is installed for user '{{ user.name }}'
  {%- endfor %}

asdf python uses XDG dirs during this salt run:
  environ.setenv:
    - value:
        ASDF_GEM_DEFAULT_PACKAGES_FILE: "{{ user.xdg.config }}/asdf/default-gems"
    - require_in:
  {%- for version in user.asdf.ruby %}
      - Ruby {{ version }} is installed for user '{{ user.name }}'
  {%- endfor %}

  {%- if user.get('persistenv') %}

persistenv file for asdf ruby for user '{{ user.name }}' exists:
  file.managed:
    - name: {{ user.home }}/{{ user.persistenv }}
    - user: {{ user.name }}
    - group: {{ user.group }}
    - replace: false
    - mode: '0600'
    - dir_mode: '0700'
    - makedirs: true

asdf python plugin knows about XDG location for user '{{ user.name }}':
  file.append:
    - name: {{ user.home }}/{{ user.persistenv }}
    - text: export ASDF_GEM_DEFAULT_PACKAGES_FILE="${XDG_CONFIG_HOME:-$HOME/.config}/asdf/default-gems"
    - require:
      - persistenv file for asdf ruby for user '{{ user.name }}' exists
    - require_in:
    {%- for version in user.asdf.ruby %}
      - Ruby {{ version }} is installed for user '{{ user.name }}'
    {%- endfor %}
  {%- endif %}
{%- endfor %}
