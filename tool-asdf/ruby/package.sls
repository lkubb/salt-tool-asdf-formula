{%- from 'tool-asdf/ruby/map.jinja' import dependencies, users, pkg_mode -%}

include:
  - ..package

Required packages for compiling Ruby are available:
  pkg.{{ pkg_mode }}:
    - pkgs: {{ dependencies }}

{%- for user in users %}
  {%- if user.asdf.get('update_auto') %}

Ruby plugin is up to date for user '{{ user.name }}':
  asdf.plugin_latest:
    - name: ruby
    - user: {{ user.name }}
  {%- endif %}

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
