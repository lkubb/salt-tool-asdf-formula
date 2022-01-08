{%- from 'tool-asdf/map.jinja' import asdf, tools %}

include:
  - .package
{%- if asdf.users | rejectattr('xdg', 'sameas', False) | list %}
  - .xdg
{%- endif %}
{%- for tool in tools %}
  {%- if asdf.users | selectattr('asdf.' ~ tool, 'defined') | list %}
  - .{{ tool }}
  {%- endif %}
{%- endfor %}
{%- if asdf.users | selectattr('asdf.system', 'defined') | list %}
  - .system
{%- endif %}
