{%- from 'tool-asdf/python/map.jinja' import dependencies, users -%}

include:
  - ..package

Required packages for compiling Python are available:
  pkg.installed:
    - pkgs: {{ dependencies }}

{%- for user in users %}
  {%- for version in user.asdf.python %}
Python {{ version }} is installed for user '{{ user.name }}':
  asdf.version_installed:
    - name: python
    - version: {{ version }}
    - user: {{ user.name }}
    - require:
      - asdf setup is completed
  {%- endfor %}
{%- endfor %}
