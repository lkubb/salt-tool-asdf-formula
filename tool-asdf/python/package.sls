{%- from 'tool-asdf/map.jinja' import asdf %}
{%- from 'tool-asdf/python/map.jinja' import dependencies -%}

include:
  - ..package

Required packages for compiling Python are available:
  pkg.installed:
    - pkgs: {{ dependencies }}

{%- for user in asdf.users | selectattr('asdf.python') %}
  {# ugly workaround for uglier statement
    {%- set versions = user.python if user.python is iterable and (user.python is not string and user.python is not mapping) else [user.python] %}#}
  {%- set versions = user.python if user.python.__class__.__name__ == 'list' else [user.python if user.python is not sameas True else 'latest'] %}
  {%- for version in versions %}
Python {{ version }} is installed for user '{{ user.name }}':
  asdf.version_installed:
    - name: python
    - version: {{ version }}
    - user: {{ user.name }}
    - require:
      - sls: ..package
  {%- endfor %}
{%- endfor %}
