{%- from 'tool-asdf/ruby/map.jinja' import dependencies, users -%}

include:
  - ..package

Required packages for compiling Ruby are available:
  pkg.installed:
    - pkgs: {{ dependencies }}

{%- for user in users %}
  {%- for version in user.asdf.ruby %}
Ruby {{ version }} is installed for user '{{ user.name }}':
  asdf.version_installed:
    - name: ruby
    - version: {{ version }}
    - user: {{ user.name }}
    - require:
      - asdf setup is completed
  {%- endfor %}
{%- endfor %}
