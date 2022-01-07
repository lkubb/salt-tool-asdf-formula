{%- from 'tool-asdf/php/map.jinja' import dependencies, users -%}

include:
  - ..package

Required packages for compiling PHP are available:
  pkg.installed:
    - pkgs: {{ dependencies }}

{%- for user in users %}
  {%- for version in user.asdf.php %}
PHP {{ version }} is installed for user '{{ user.name }}':
  asdf.version_installed:
    - name: php
    - version: {{ version }}
    - user: {{ user.name }}
    - require:
      - asdf setup is completed
  {%- endfor %}
{%- endfor %}
