{%- from 'tool-asdf/nodejs/map.jinja' import dependencies, users, pkg_mode -%}

include:
  - ..package

Required packages for compiling NodeJS are available:
  pkg.{{ pkg_mode }}:
    - pkgs: {{ dependencies }}

{%- for user in users %}
  {%- if user.asdf.get('update_auto') %}

NodeJS plugin is up to date for user '{{ user.name }}':
  asdf.plugin_latest:
    - name: nodejs
    - user: {{ user.name }}
  {%- endif %}

  {%- for version in user.asdf.nodejs %}

NodeJS {{ version }} is installed for user '{{ user.name }}':
  asdf.version_installed:
    - name: nodejs
    - version: {{ version }}
    - user: {{ user.name }}
    - require:
      - asdf setup is completed
  {%- endfor %}
{%- endfor %}
