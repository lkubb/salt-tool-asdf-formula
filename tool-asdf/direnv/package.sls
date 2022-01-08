{%- from 'tool-asdf/direnv/init.sls' import users %}

include:
  - ..package

{%- for user in users %}
  {%- if user.asdf.get('update_auto') %}

Direnv plugin is up to date for user '{{ user.name }}':
  asdf.plugin_latest:
    - name: direnv
    - user: {{ user.name }}
  {%- endif %}

  {%- for version in user.asdf.direnv %}

direnv {{ version }} is installed for user '{{ user.name }}':
  asdf.version_installed:
    - name: direnv
    - version: {{ version }}
    - user: {{ user.name }}
    - require:
      - asdf setup is completed
  {%- endfor %}
{%- endfor %}
