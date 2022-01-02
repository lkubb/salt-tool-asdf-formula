{%- from 'tool-asdf/php/map.jinja' import dependencies, users -%}

include:
  - ..package

Required packages for compiling PHP are available:
  pkg.installed:
    - pkgs: {{ dependencies }}

{%- for user in users %}
  {# ugly workaround for uglier statement
    {%- set versions = user.php if user.php is iterable and (user.php is not string and user.php is not mapping) else [user.php] %}#}
  {%- set versions = user.php if user.php.__class__.__name__ == 'list' else [user.php if user.php is not sameas True else 'latest'] %}
  {%- for version in versions %}
PHP {{ version }} is installed for user '{{ user.name }}':
  asdf.version_installed:
    - name: php
    - version: {{ version }}
    - user: {{ user.name }}
    - require:
      - sls: ..package
  {%- endfor %}
{%- endfor %}
