{%- from 'tool-asdf/map.jinja' import asdf %}

include:
{%- if asdf.users | rejectattr('xdg', 'sameas', False) %}
  - .xdg
{%- endif %}
  - .package
