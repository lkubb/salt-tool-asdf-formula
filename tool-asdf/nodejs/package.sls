{%- from 'tool-asdf/nodejs/map.jinja' import dependencies, users -%}

include:
  - ..package

Required packages for compiling NodeJS are available:
  pkg.installed:
    - pkgs: {{ dependencies }}

{%- for user in users %}
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
