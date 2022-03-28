# -*- coding: utf-8 -*-
# vim: ft=sls

{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/python/map.jinja" import users %}

include:
  - .package

{%- for user in users | rejectattr('xdg', 'sameas', False) %}
asdf python plugin global configuration is migrated to XDG_CONFIG_HOME for user '{{ user.name }}':
  file.rename:
    - name: {{ user.xdg.config }}/asdf/default-python-packages
    - source: {{ user.home }}/.default-python-packages
    - makedirs: true
    - onlyif:
      - test -e {{ user.home }}/.default-python-packages
    - require_in:
  {%- for version in user.asdf.python %}
      - Python {{ version }} is installed for user '{{ user.name }}'
  {%- endfor %}

asdf python uses XDG dirs during this salt run:
  environ.setenv:
    - value:
        ASDF_PYTHON_DEFAULT_PACKAGES_FILE: "{{ user.xdg.config }}/asdf/default-python-packages"
    - require_in:
  {%- for version in user.asdf.python %}
      - Python {{ version }} is installed for user '{{ user.name }}'
  {%- endfor %}

  {%- if user.get('persistenv') %}

persistenv file for asdf python for user '{{ user.name }}' exists:
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
    - text: export ASDF_PYTHON_DEFAULT_PACKAGES_FILE="${XDG_CONFIG_HOME:-$HOME/.config}/asdf/default-python-packages"
    - require:
      - persistenv file for asdf python for user '{{ user.name }}' exists
    - require_in:
    {%- for version in user.asdf.python %}
      - Python {{ version }} is installed for user '{{ user.name }}'
    {%- endfor %}
  {%- endif %}
{%- endfor %}
