{%- from 'tool-asdf/python/map.jinja' import users -%}

include:
  - ..package
  - .deps

{%- for user in users %}
  {%- if user.asdf.get('update_auto') %}

Python plugin is up to date for user '{{ user.name }}':
  asdf.plugin_latest:
    - name: python
    - user: {{ user.name }}
  {%- endif %}

  {%- for version in user.asdf.python %}

Python {{ version }} is installed for user '{{ user.name }}':
  asdf.version_installed:
    - name: python
    - version: {{ version }}
    - user: {{ user.name }}
    - require:
      - asdf setup is completed
      - Required packages for compiling Python are available
  {%- endfor %}
{%- endfor %}
