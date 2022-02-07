{%- from 'tool-asdf/map.jinja' import asdf %}

{%- for user in asdf.users | selectattr('asdf.system', 'defined') %}
  {%- for tool, version in user.asdf.system.items() %}

User '{{ user.name }}' system default {{ tool }} {{ version }} is installed:
  asdf.version_installed:
    - name: {{ tool }}
    - version: {{ version }}
    - user: {{ user.name }}
    - require:
      - asdf setup is completed

User '{{ user.name }}' uses {{ tool }} {{ version }} by default:
  asdf.version_set:
    - name: {{ tool }}
    - version: {{ version }}
    - user: {{ user.name }}
    - require:
      - User '{{ user.name }}' system default {{ tool }} {{ version }} is installed
  {%- endfor %}
{%- endfor %}
