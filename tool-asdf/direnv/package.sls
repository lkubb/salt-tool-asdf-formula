{%- from 'tool-asdf/map.jinja' import asdf %}

include:
  - ..package

{%- for user in asdf.users | selectattr('asdf.direnv') %}
  {# ugly workaround for uglier statement
    {%- set versions = user.direnv if user.direnv is iterable and (user.direnv is not string and user.direnv is not mapping) else [user.direnv] %}#}
  {%- set versions = user.direnv if user.direnv.__class__.__name__ == 'list' else [user.direnv if user.direnv is not sameas True else 'latest'] %}
  {%- for version in versions %}
direnv {{ version }} is installed for user '{{ user.name }}':
  asdf.version_installed:
    - name: direnv
    - version: {{ version }}
    - user: {{ user.name }}
    - require:
      - sls: ..package
  {%- endfor %}
{%- endfor %}
