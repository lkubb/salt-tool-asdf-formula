{%- from 'tool-asdf/nodejs/map.jinja' import dependencies -%}

include:
  - ..package

Required packages for compiling NodeJS are available:
  pkg.installed:
    - pkgs: {{ dependencies }}

{%- for user in salt['pillar.get']('tool:asdf', []) | selectattr('nodejs') %}
  {# ugly workaround for uglier statement
    {%- set versions = user.nodejs if user.nodejs is iterable and (user.nodejs is not string and user.nodejs is not mapping) else [user.nodejs] %}#}
  {%- set versions = user.nodejs if user.nodejs.__class__.__name__ == 'list' else [user.nodejs if user.nodejs is not sameas True else 'latest'] %}
  {%- for version in versions %}
NodeJS {{ version }} is installed for user '{{ user.name }}':
  asdf.version_installed:
    - name: nodejs
    - version: {{ version }}
    - user: {{ user.name }}
    - require:
      - sls: ..package
  {%- endfor %}
{%- endfor %}
