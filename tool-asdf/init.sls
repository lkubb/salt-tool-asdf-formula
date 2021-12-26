{%- from 'tool-asdf/map.jinja' import tools %}

{%- set users = salt['pillar.get']('tool:asdf', []) -%}

include:
  - .package
{%- if users | rejectattr('xdg', 'sameas', False) %}
  - .xdg
{%- endif %}
{%- for tool in tools %}
  {%- if users | selectattr(tool) %}
  - .{{ tool }}
  {%- endif %}
{%- endfor %}
{%- if users | selectattr('system') %}
  - .system
{%- endif %}
