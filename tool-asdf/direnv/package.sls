{%- from 'tool-asdf/direnv/init.sls' import users %}

include:
  - ..package

{%- for user in users %}
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
