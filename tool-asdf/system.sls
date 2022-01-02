{%- from 'tool-asdf/map.jinja' import asdf %}

{%- for user in asdf.users | selectattr('asdf.system', 'defined') %}
  {%- for tool, version in user.asdf.system.items() %}
User '{{ user.name }} uses {{ tool }} {{ version }} by default:
  asdf.version_set:
    - name: {{ tool }}
    - version: {{ version }}
    - user: {{ user.name }}
  {%- endif %}
{%- endfor %}
