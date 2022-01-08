{%- from 'tool-asdf/golang/map.jinja' import dependencies, users, pkg_mode -%}

include:
  - ..package

Required packages for compiling Go are available:
  pkg.{{ pkg_mode }}:
    - pkgs: {{ dependencies }}

{%- for user in users %}
  {%- if user.asdf.get('update_auto') %}

Golang plugin is up to date for user '{{ user.name }}':
  asdf.plugin_latest:
    - name: golang
    - user: {{ user.name }}
  {%- endif %}

  {%- for version in user.asdf.golang %}

Go {{ version }} is installed for user '{{ user.name }}':
  asdf.version_installed:
    - name: golang
    - version: {{ version }}
    - user: {{ user.name }}
    - require:
      - asdf setup is completed
  {%- endfor %}
{%- endfor %}
