# -*- coding: utf-8 -*-
# vim: ft=sls

{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/nodejs/map.jinja" import users %}

include:
  - .package


{%- for user in users | rejectattr('xdg', 'sameas', false) %}

asdf node plugin global configuration is migrated to XDG_CONFIG_HOME for user '{{ user.name }}':
  file.rename:
    - name: {{ user.xdg.config | path_join(asdf.lookup.paths.xdg_dirname, asdf.lookup.nodejs_paths.xdg_conffile) }}
    - source: {{ user.home | path_join(asdf.lookup.nodejs_paths.confdir, asdf.lookup.nodejs_paths.conffile) }}
    - makedirs: true
    - require_in:
      - asdf nodejs setup is completed
{%-   for version in user.asdf.get("nodejs", []) %}
      - NodeJS {{ version }} is installed for user '{{ user.name }}'
{%-   endfor %}

asdf node uses XDG dirs during this salt run:
  environ.setenv:
    - value:
        ASDF_NPM_DEFAULT_PACKAGES_FILE: "{{ user.xdg.config | path_join(asdf.lookup.paths.xdg_dirname, asdf.lookup.nodejs_paths.xdg_conffile) }}"
    - require_in:
      - asdf nodejs setup is completed
{%-   for version in user.asdf.get("nodejs", []) %}
      - NodeJS {{ version }} is installed for user '{{ user.name }}'
{%-   endfor %}

{%-   if user.get('persistenv') %}

persistenv file for asdf nodejs for user '{{ user.name }}' exists:
  file.managed:
    - name: {{ user.home | path_join(user.persistenv) }}
    - user: {{ user.name }}
    - group: {{ user.group }}
    - replace: false
    - mode: '0600'
    - dir_mode: '0700'
    - makedirs: true

asdf node plugin knows about XDG location for user '{{ user.name }}':
  file.append:
    - name: {{ user.home | path_join(user.persistenv) }}
    - text: export ASDF_NPM_DEFAULT_PACKAGES_FILE="${XDG_CONFIG_HOME:-$HOME/.config}/{{ asdf.lookup.paths.xdg_dirname |
              path_join(asdf.lookup.nodejs_paths.xdg_conffile) ~ '"' }}
    - require:
      - persistenv file for asdf nodejs for user '{{ user.name }}' exists
    - require_in:
      - asdf nodejs setup is completed
{%-   for version in user.asdf.get("nodejs", []) %}
      - NodeJS {{ version }} is installed for user '{{ user.name }}'
{%-     endfor %}
{%-   endif %}
{%- endfor %}
