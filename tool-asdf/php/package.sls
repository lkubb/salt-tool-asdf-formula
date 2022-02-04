{%- from 'tool-asdf/php/map.jinja' import users -%}

include:
  - ..package
  - .deps

{%- for user in users %}
  {%- if user.asdf.get('update_auto') %}

PHP plugin is up to date for user '{{ user.name }}':
  asdf.plugin_latest:
    - name: php
    - user: {{ user.name }}
  {%- endif %}

  {%- for version in user.asdf.php %}

PHP {{ version }} is installed for user '{{ user.name }}':
  asdf.version_installed:
    - name: php
    - version: {{ version }}
    - user: {{ user.name }}
    - require:
      - asdf setup is completed
      - Required packages for compiling PHP are available
  {%- endfor %}
{%- endfor %}
