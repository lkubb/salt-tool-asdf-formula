{%- from 'tool-asdf/map.jinja' import asdf %}
{%- from 'tool-asdf/golang/map.jinja' import dependencies -%}

include:
  - ..package

Required packages for compiling Go are available:
  pkg.installed:
    - pkgs: {{ dependencies }}

{%- for user in asdf.users | selectattr('asdf.golang') %}
  {# ugly workaround for uglier statement
    {%- set versions = user.golang if user.golang is iterable and (user.golang is not string and user.golang is not mapping) else [user.golang] %}#}
  {%- set versions = user.golang if user.golang.__class__.__name__ == 'list' else [user.golang if user.golang is not sameas True else 'latest'] %}
  {%- for version in versions %}
Go {{ version }} is installed for user '{{ user.name }}':
  asdf.version_installed:
    - name: golang
    - version: {{ version }}
    - user: {{ user.name }}
    - require:
      - sls: ..package
  {%- endfor %}
{%- endfor %}
