{%- for user in salt['pillar.get']('tool:asdf', []) | selectattr('system') %}
  {%- for tool, version in user.system.items() %}
User '{{ user.name }} uses {{ tool }} {{ version }} by default:
  asdf.version_set:
    - name: {{ tool }}
    - version: {{ version }}
    - user: {{ user.name }}
  {%- endif %}
{%- endfor %}
