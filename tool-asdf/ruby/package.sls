{%- from 'tool-asdf/map.jinja' import asdf %}
{%- from 'tool-asdf/ruby/map.jinja' import dependencies -%}

include:
  - ..package

Required packages for compiling Ruby are available:
  pkg.installed:
    - pkgs: {{ dependencies }}

{%- for user in asdf.users | selectattr('asdf.ruby') %}
  {# ugly workaround for uglier statement
    {%- set versions = user.ruby if user.ruby is iterable and (user.ruby is not string and user.ruby is not mapping) else [user.ruby] %}#}
  {%- set versions = user.ruby if user.ruby.__class__.__name__ == 'list' else [user.ruby if user.ruby is not sameas True else 'latest'] %}
  {%- for version in versions %}
Ruby {{ version }} is installed for user '{{ user.name }}':
  asdf.version_installed:
    - name: ruby
    - version: {{ version }}
    - user: {{ user.name }}
    - require:
      - sls: ..package
  {%- endfor %}
{%- endfor %}
