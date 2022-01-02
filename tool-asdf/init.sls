{%- from 'tool-asdf/map.jinja' import asdf, tools %}

include:
  - .package
{%- if asdf.users | rejectattr('xdg', 'sameas', False) %}
  - .xdg
{%- endif %}
{%- for tool in tools %}
  {%- if asdf.users | selectattr('asdf.' ~ tool, 'defined') %}
  - .{{ tool }}
  {%- endif %}
{%- endfor %}
{%- if asdf.users | selectattr('asdf.system', 'defined') %}
  - .system
{%- endif %}
