{%- from 'tool-asdf/python/map.jinja' import users -%}

include:
{%- if users | rejectattr('xdg', 'sameas', False) | list %}
  - .xdg
{%- endif %}
  - .package
